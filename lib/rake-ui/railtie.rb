module RakeUi
  class Railtie < Rails::Railtie
    rake_tasks do
      load 'tasks/rake_ui/tasks.rake'
    end
  end
end