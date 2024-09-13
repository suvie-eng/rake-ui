class CreateRakeTaskLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :rake_task_logs, if_not_exists: true do |t|
      t.integer :status, default: 0
      t.string :name
      t.string :args
      t.string :environment
      t.string :rake_command
      t.string :rake_definition_file
      t.string :log_file_name
      t.string :log_file_full_path
      t.string :raker_id
      t.timestamps
    end
  end
end