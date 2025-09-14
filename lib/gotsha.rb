# frozen_string_literal: true

require "fileutils"

require_relative "gotsha/version"

module Gotsha
  class NoCommandConfigured < StandardError; end

  CONFIG_DIR = ".gotsha"
  COMMANDS_FILE = "#{CONFIG_DIR}/commands".freeze
  LAST_SUCCESS_FILE = "#{CONFIG_DIR}/last_success".freeze

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

      if Kernel.system(command)
        puts "YAY, writing commit SHA..."
        File.write(LAST_SUCCESS_FILE, last_commit_sha)
      else
        puts "FUCK"
      end
    end

    def verify
      if checked?
        puts "✓ gotsha: HEAD matches #{stored_sha}"
        exit 0
      else
        puts "✗ gotsha: HEAD=#{last_commit_sha} != stored=#{stored_sha.inspect}"
        exit 1
      end
    end

    private

    def checked?
      return false unless File.exist?(LAST_SUCCESS_FILE)

      stored_sha == last_commit_sha
    end

    def stored_sha
      @stored_sha ||= File.read(LAST_SUCCESS_FILE).strip rescue nil
    end

    def last_commit_sha
      @last_commit_sha ||= `git rev-parse HEAD`.strip
    end
  end
end
