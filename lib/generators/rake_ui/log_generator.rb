require 'rails/generators'
require 'rails/generators/migration'
require 'rails/generators/active_record/migration'
module RakeUi
  module Generators
    class LogGenerator < Rails::Generators::Base
      include Rails::Generators::Migration

      source_root File.expand_path('templates', __dir__)

      def create_rake_task_logs_migration
        migration_template "create_rake_task_logs.rb", "db/migrate/create_rake_task_logs.rb"
      end

      def self.next_migration_number(dirname)
        Time.now.utc.strftime("%Y%m%d%H%M%S")
      end
    end
  end
end
