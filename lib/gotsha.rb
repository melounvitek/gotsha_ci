# frozen_string_literal: true

require "fileutils"

require_relative "gotsha/version"

module Gotsha
  class NoCommandConfigured < StandardError; end

  CONFIG_DIR = ".gotsha"
  COMMANDS_FILE = "#{CONFIG_DIR}/commands"
  LAST_SUCCESS_FILE = "#{CONFIG_DIR}/last_success"

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

      puts "Configure git notes to store Gotsha checks..."
      Kernel.system("git config --local notes.displayRef refs/notes/gotsha")

      # fetch/push just gotsha notes
      Kernel.system("git config --local --add remote.origin.fetch 'refs/notes/gotsha:refs/notes/gotsha'")
      Kernel.system("git config --local --add remote.origin.push  'refs/notes/gotsha'")

      puts "✓ Done"
    end

    def run
      raise NoCommandConfigured unless File.exist?(COMMANDS_FILE)

      command = File.read(Gotsha::COMMANDS_FILE)

      return unless Kernel.system(command)

      Kernel.system("git notes --ref=gotsha add -f -m 'ok'")
      puts "✅ gotsha: verified for #{last_commit_sha}"
    end

    def verify
      if last_comment_note == "ok"
        puts "✓ gotsha: #{last_commit_sha} verified"
        exit 0
      else
        puts "✗ gotsha: #{last_commit_sha} was not verified"
        exit 1
      end
    end

    private

    def last_comment_note
      `git notes --ref=gotsha show #{last_commit_sha} 2>/dev/null`.strip
    end

    def last_commit_sha
      @last_commit_sha ||= `git rev-parse HEAD`.strip
    end
  end
end
