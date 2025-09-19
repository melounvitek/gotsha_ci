# frozen_string_literal: true

require "English"
require_relative "config"

module Gotsha
  class BashCommand
    def self.run!(command)
      output = []

      IO.popen(command) do |io|
        io.each do |line|
          Config::USER_CONFIG["debug"] && puts(line)
          output << line
        end
      end

      new(output.join("\n"), $CHILD_STATUS)
    end

    def initialize(stdout, status)
      @stdout = stdout
      @status = status
    end

    def success?
      @status.success?
    end

    def text_output
      @stdout
    end

    def self.silent_run!(command)
      return run!(command) if Config::USER_CONFIG["debug"]

      run!("#{command} > /dev/null 2>&1")
    end
  end
end
