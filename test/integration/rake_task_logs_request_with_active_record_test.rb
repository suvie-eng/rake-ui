# frozen_string_literal: true

require "test_helper"

class RakeTaskLogsRequestWithActiveRecordTest < ActionDispatch::IntegrationTest
  setup do
    RakeUi.configuration.active_storage = true

    @file = Rack::Test::UploadedFile.new(Rails.root.join('fixtures/sample_log.txt'), 'text/plain')
    @rake_task_log = ::RakeTaskLog.create!(
      slug: 'test-file',
      status: 1,
      name: 'Test Rake Task',
      args: 'arg1,arg2',
      environment: 'test',
      rake_command: 'rake test',
      rake_definition_file: 'definition_file.rake',
      log_file: @file,  # Attach the file
      log_file_name: 'sample_log.txt',
      log_file_full_path: '/path/to/sample_log.txt',
      raker_id: 'rake-id'
    )
  end

  test "index html responds successfully" do
    get "/rake-ui/rake_task_logs"

    assert_equal 200, status
  end

  test "index json responds successfully" do
    get "/rake-ui/rake_task_logs.json"

    assert_equal 200, status
    assert_instance_of Array, json_response[:rake_task_logs]
  end

  test "show html responds with the content" do
    log = ::RakeTaskLog.all.first
    get "/rake-ui/rake_task_logs/#{@rake_task_log.id}"

    assert_equal 200, status
    assert_includes response.body, "INVOKED RAKE TASK OUTPUT BELOW"
  end

  test "show json responds with the content and task log meta" do
    log = ::RakeTaskLog.all.first
    get "/rake-ui/rake_task_logs/#{log.id}.json"
    assert_equal 200, status
    assert_equal log.id, json_response[:rake_task_log][:id]
    assert_equal log.log_file_name, json_response[:rake_task_log][:log_file_name]
  end
end
