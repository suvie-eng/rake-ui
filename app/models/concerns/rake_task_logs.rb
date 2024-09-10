module RakeTaskLogs
  extend ActiveSupport::Concern
  ID_DATE_FORMAT = "%Y-%m-%d-%H-%M-%S%z"
  REPOSITORY_DIR = Rails.root.join("tmp", "rake_ui")
  FILE_DELIMITER = "____"
  TASK_HEADER_OUTPUT_DELIMITER = "-------------------------------"
  FILE_ITEM_SEPARATOR = ": "
  FINISHED_STRING = "+++++ COMMAND FINISHED +++++"
  INPROGRESS = "Task is in Progress...."
  NOT_AVAILABLE = "Log File Not Avaialable..."


  class_methods do
    def create_tmp_file_dir
      FileUtils.mkdir_p(REPOSITORY_DIR.to_s)
    end

    def generate_task_attributes(raker_id:)
      date = Time.now.strftime(ID_DATE_FORMAT)
      id = "#{date}#{FILE_DELIMITER}#{raker_id}"
      log_file_name = "#{id}.txt"
      log_file_full_path = REPOSITORY_DIR.join(log_file_name).to_s
      {
        date:,
        id:,
        log_file_name:,
        log_file_full_path:
      }
    end
  end

  def rake_command_with_logging
    "#{rake_command} 2>&1 >> #{log_file_full_path}"
  end

  def command_to_mark_log_finished
    "echo #{FINISHED_STRING} >> #{log_file_full_path}"
  end
end
