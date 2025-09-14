# frozen_string_literal: true

require "fileutils"

require_relative "gotsha/version"

module Gotsha
  # STFU Rubocop :-)
  class CLI
    def self.call(command) = new.public_send(command)

    def init
      puts "Creating default config files..."
      FileUtils.mkdir_p(".gotsha")
      FileUtils.touch(".gotsha/commands")
      puts "Done"
    end
  end
end
