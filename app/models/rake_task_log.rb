class RakeTaskLog < ApplicationRecord
  include RakeTaskLogs

  ATTRIBUTES_TO_SHOW = %w[id name date args environment rake_command rake_definition_file log_file_name log_file_full_path]
  has_one_attached :log_file
  enum status: { in_progress: 0, finished: 1 }

  def self.build_new_for_command(name:, rake_definition_file:, rake_command:, raker_id:, args: nil, environment: nil)
    create_tmp_file_dir
    generate_file_content(log_file_full_path: generate_task_attributes(raker_id:)[:log_file_full_path])
    create_rake_task_log(name:, args:, environment:, rake_command:, rake_definition_file:, raker_id:)
  end

  def self.generate_file_content(log_file_full_path:)
    File.open(log_file_full_path, "w+") do |f|
      f.puts TASK_HEADER_OUTPUT_DELIMITER.to_s
      f.puts " INVOKED RAKE TASK OUTPUT BELOW"
      f.puts TASK_HEADER_OUTPUT_DELIMITER.to_s
    end
  end

  def self.create_rake_task_log(name:, args:, environment:, rake_command:, rake_definition_file:, raker_id:)
    attributes = generate_task_attributes(raker_id:)

    ::RakeTaskLog.create(name:,
                         args:,
                         environment:,
                         rake_command:,
                         rake_definition_file:,
                         log_file_name: attributes[:log_file_name],
                         log_file_full_path:  attributes[:log_file_full_path],
                         raker_id:)
  end

  def attach_file_with_rake_task_log
    if File.exist?(log_file_full_path)
      log_file.attach(io: File.open(log_file_full_path), filename: 'log.txt')
    end
    self.status = :finished
    self.save!
    File.delete(log_file_full_path)
  end

  def file_contents
    return INPROGRESS unless finished?

    log_file.download if log_file.attached?
  end

  def date
    created_at
  end

end
