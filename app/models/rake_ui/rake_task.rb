# frozen_string_literal: true

module RakeUi
  class RakeTask
    def self.to_safe_identifier(id)
      CGI.escape(id)
    end

    def self.from_safe_identifier(id)
      CGI.unescape(id)
    end

    def self.load
      # Enables 'desc' to show up as full_comments
      if Rake::TaskManager.respond_to? :record_task_metadata
        Rake::TaskManager.record_task_metadata = true
      end

      Rails.application.load_tasks
      Rake::Task.tasks
    end

    def self.all
      self.load.map do |task|
        new(task)
      end
    end

    def self.internal
      self.load.map { |task|
        new(task)
      }.select(&:is_internal_task)
    end

    def self.find_by_id(id)
      t = all
      i = from_safe_identifier(id)

      t.find do |task|
        task.name == i
      end
    end

    attr_reader :task
    delegate :name, :actions, :name_with_args, :arg_description, :full_comment, :locations, :sources, to: :task

    def initialize(task)
      @task = task
    end

    def id
      RakeUi::RakeTask.to_safe_identifier(name)
    end

    # actions will be something like #<Proc:0x000055a2737fe778@/some/rails/app/lib/tasks/auto_annotate_models.rake:4>
    def rake_definition_file
      definition = actions.first || ""

      if definition.respond_to?(:source_location)
        definition.source_location.join(":")
      else
        definition
      end
    rescue
      "unable_to_determine_defining_file"
    end

    def is_internal_task
      internal_task?
    end

    # thinking this is the sanest way to discern application vs gem defined tasks (like rails, devise etc)
    def internal_task?
      actions.any? { |a| !a.to_s.include? "/ruby/gems" }

      # this was my initial thought here, leaving for posterity in case we need to or the definition of custom
      # from initial investigation the actions seemed like the most consistent as locations is sometimes empty
      # locations.any? do |location|
      #   !location.match(/\/bundle\/gems/)
      # end
    end

    def call(args: nil, environment: nil)
      rake_command = build_rake_command(args: args, environment: environment)
      rake_task_log = klass.build_new_for_command(
        name: name,
        args: args,
        environment: environment,
        rake_command: rake_command,
        rake_definition_file: rake_definition_file,
        raker_id: id
      )

      puts "[rake_ui] [rake_task] [forked] #{rake_task_log.rake_command_with_logging}"

      fork do
        system(rake_task_log.rake_command_with_logging)

        system(rake_task_log.command_to_mark_log_finished)
        rake_task_log.attach_file_with_rake_task_log if RakeUi.configuration.active_storage
      end

      rake_task_log
    end

    # returns an invokable rake command
    # FOO=bar rake create_something[1,2,3]
    # rake create_something[1,2,3]
    # rake create_something
    def build_rake_command(args: nil, environment: nil)
      command = ""

      if environment
        command += "#{environment} "
      end

      command += "rake #{name}"

      if args
        command += "[#{args}]"
      end

      command
    end

    def klass
      @klass ||= RakeUi.configuration.active_storage ? ::RakeTaskLog : RakeUi::RakeTaskLog
    end
  end
end
