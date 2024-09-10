class CreateRakeTaskLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :rake_task_logs do |t|
      t.string :slug, unique: true
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

    add_index :rake_task_logs, :slug, unique: true
  end
end