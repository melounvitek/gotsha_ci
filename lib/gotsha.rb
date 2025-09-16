# frozen_string_literal: true

require "fileutils"
require "yaml"

require_relative "gotsha/version"

module Gotsha
  class NoCommandConfigured < StandardError; end

  CONFIG_DIR = ".gotsha"
  CONFIG_FILE   = File.join(CONFIG_DIR, "config.yml")
  TEMPLATE_PATH = File.expand_path("gotsha/templates/config.yml", __dir__)

  # Main entry
  class CLI
    def self.call(action = :run)
      action ||= :run

      new.public_send(action)
    end

    def init
      puts "Creating default config files..."

      unless File.exist?(CONFIG_FILE)
        FileUtils.mkdir_p(CONFIG_DIR)

        File.write(CONFIG_FILE, File.read(TEMPLATE_PATH))
      end

      puts "Configure git notes to store Gotsha checks..."
      Kernel.system("git config --local notes.displayRef refs/notes/gotsha")

      Kernel.system("git config --local --replace-all remote.origin.push HEAD")
      Kernel.system("git config --local --add remote.origin.push refs/notes/gotsha")
      Kernel.system("git config --local --replace-all remote.origin.fetch refs/notes/gotsha:refs/notes/gotsha")

      puts "✓ Done"
    end

    def run
      commands = YAML.load_file(CONFIG_FILE).fetch("commands").join(" && ")

      raise NoCommandConfigured if commands.to_s.empty?

      return unless Kernel.system(commands)

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
