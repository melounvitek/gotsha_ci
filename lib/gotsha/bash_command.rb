# frozen_string_literal: true

require "pty"

module Gotsha
  class BashCommand
    def self.run!(command)
      Config::USER_CONFIG["verbose"] && puts(command)

      stdout = +""
      status = nil

      PTY.spawn(command) do |r, _, pid|
        r.each do |line|
          Config::USER_CONFIG["verbose"] && puts(line)
          stdout << line
        end
      rescue Errno::EIO
        # expected when the child closes the PTY
      ensure
        _, ps = Process.wait2(pid)
        status = ps
      end

      new(stdout, status)
    end

    def self.silent_run!(command)
      return run!(command) if Config::USER_CONFIG["verbose"]

      run!("#{command} 2>&1")
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
  end
end
