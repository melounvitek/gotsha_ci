# frozen_string_literal: true

require "fileutils"

require_relative "gotsha/version"

module Gotsha
  class NoCommandConfigured < StandardError; end

  CONFIG_DIR = ".gotsha"
  COMMANDS_FILE = "#{CONFIG_DIR}/commands"

  # Main entry
  class CLI
    def self.call(action = :run)
      action ||= :run

      new.public_send(action)
    end

    def init
      puts "Creating default config files..."

      FileUtils.mkdir_p(CONFIG_DIR)
      FileUtils.touch(COMMANDS_FILE)

      puts "Done"
    end

    def run
      raise NoCommandConfigured unless File.exist?(COMMANDS_FILE)

      command = File.read(Gotsha::COMMANDS_FILE)

      # system(command) TODO: causes recursion
    end
  end
end
