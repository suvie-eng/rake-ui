# frozen_string_literal: true

require "rake"
require "fileutils"
require "open3"

module RakeUi
  class Engine < ::Rails::Engine
    isolate_namespace RakeUi
    initializer "rake_ui.load_migrations" do |app|
      if RakeUi.configuration.active_storage
        unless app.root.to_s.match?(RakeUi::Engine.root.to_s)
          app.config.paths['db/migrate'].concat(
            RakeUi::Engine.paths['db/migrate'].existent
          )
        end
      end
    end
  end
end
