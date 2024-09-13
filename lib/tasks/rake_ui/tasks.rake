# frozen_string_literal: true

# desc "Explaining what the task does"
# task :rake_ui do
#   # Task goes here
# end
namespace :rake_ui do
  desc "Runs the migrations for Rake Ui"
  task :migrate => :environment do
    ActiveRecord::MigrationContext.new(File.expand_path('../../../db/migrate', __dir__)).migrate
  end
end