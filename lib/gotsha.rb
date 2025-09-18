# frozen_string_literal: true

require "fileutils"
require "yaml"

require_relative "gotsha/actions/init"
require_relative "gotsha/actions/run"
require_relative "gotsha/actions/verify"
require_relative "gotsha/config"
require_relative "gotsha/errors"
require_relative "gotsha/version"

module Gotsha
  include Config
  include Errors

  class ActionDispatcher
    def self.call(action_name = "run")
      action_name ||= "run"
      action = Kernel.const_get("Gotsha::Actions::#{action_name.capitalize}")

      action.new.call
    end
  end
end
