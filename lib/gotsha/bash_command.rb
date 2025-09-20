# frozen_string_literal: true

require "English"
require_relative "config"

module Gotsha
  class BashCommand
    def self.run!(command)
      Config::USER_CONFIG["verbose"] && puts(command)
      output = []

      IO.popen(command) do |io|
        io.each do |line|
          Config::USER_CONFIG["verbose"] && puts(line)

          output << line
        end
      end

      new(output.join, $CHILD_STATUS)
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
      return run!(command) if Config::USER_CONFIG["verbose"]

      run!("#{command} > /dev/null 2>&1")
    end
  end
end
