# frozen_string_literal: true

require "fileutils"
require "yaml"

require_relative "gotsha/action_dispatcher"
require_relative "gotsha/config"
require_relative "gotsha/errors"
require_relative "gotsha/version"

module Gotsha
  include Config
  include Errors
end
