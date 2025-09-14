# frozen_string_literal: true

require "fileutils"

require_relative "gotsha/version"

module Gotsha
  class CLI
    def self.call(command)
      new.public_send(command)
    end

    def init
      FileUtils.mkdir_p(".gotsha")
      FileUtils.touch(".gotsha/commands")
    end
  end
end
