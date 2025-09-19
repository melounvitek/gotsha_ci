# frozen_string_literal: true

require "English"

module Gotsha
  class BashCommand
    def self.run!(command)
      stdout = `#{command}`

      # puts stdout

      new(stdout, $CHILD_STATUS)
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
