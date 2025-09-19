# frozen_string_literal: true

require "fileutils"
require "yaml"
require_relative "actions/init"
require_relative "actions/run"
require_relative "actions/verify"
require_relative "config"

module Gotsha
  class ActionDispatcher
    def self.call(action_name = "run")
      action_name ||= "run"
      action = Kernel.const_get("Gotsha::Actions::#{action_name.capitalize}")

      action.new.call
    rescue NameError
      raise Errors::ActionFailed, "unknown command `#{action_name}`"
    end
  end
end
