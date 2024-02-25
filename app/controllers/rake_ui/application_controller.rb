# frozen_string_literal: true

module RakeUi
  class ApplicationController < ActionController::Base
    before_action :black_hole_production
    before_action :auth_validate
    before_action :policy_validate

    # include Pundit::Authorization

    # before_action :authorize_pundit
    # before_action :authorize!

    private

    def authorize_pundit
      r = 3
      @current_user = authenticate_admin_user!
      authorize(@current_user)
      # binding.pry
      # authorize :rake_tasks, :show?
    end

    def black_hole_production
      return if Rails.env.test? || Rails.env.development? || RakeUi.configuration.allow_production

      raise ActionController::RoutingError, "Not Found"
    end

    def auth_validate
      return true unless RakeUi.configuration.auth_engine

      if defined?(RakeUi.configuration.auth_engine)
        cb = RakeUi.configuration.auth_callback
        return false unless cb && (cb.class == Proc)
        RakeUi.configuration.auth_callback.call(self)
      end
    end

    def policy_validate
      return true unless RakeUi.configuration.policy_engine

      if defined?(RakeUi.configuration.policy_engine)
        cb = RakeUi.configuration.policy_callback
        return false unless cb && (cb.class == Proc)
        RakeUi.configuration.policy_callback.call(self)
      end
    end
  end
end
