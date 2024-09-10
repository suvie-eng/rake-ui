# frozen_string_literal: true

module RakeUi
  module RakeTaskLogHelper
    def attributers_to_show
      RakeUi.configuration.active_storage ? ::RakeTaskLog::ATTRIBUTES_TO_SHOW : []
    end
  end
end
