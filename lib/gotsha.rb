# frozen_string_literal: true

require_relative "gotsha/version"

module Gotsha
  class CLI
    def self.call(command)
      p command
      puts "Yay!"
    end
  end
end
