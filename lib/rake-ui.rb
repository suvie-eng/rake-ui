# frozen_string_literal: true

require "rake-ui/engine"

module RakeUi
  mattr_accessor :allow_production
  mattr_accessor :allow_staging
  mattr_accessor :policy_engine
  mattr_accessor :policy_callback
  mattr_accessor :auth_engine
  mattr_accessor :auth_callback
  mattr_accessor :active_storage
  mattr_accessor :storage_service

  self.active_storage = false
  self.allow_production = false
  self.allow_staging = true
  self.policy_engine = nil
  self.policy_callback = nil
  self.auth_engine = nil
  self.auth_callback = nil
  self.storage_service = nil

  def self.configuration
    yield(self) if block_given?
    self
  end
end
