# frozen_string_literal: true

module Gotsha
  module Actions
    class Run
      def call
        commands = Array(Gotsha::Config::USER_CONFIG.fetch("commands"))

        if commands.empty?
          raise(Errors::ActionFailed,
                "please, define some test commands in `.gotsha/config.yml`")
        end

        commands.each do |command|
          puts "Running `#{command}`..."

          command_result = BashCommand.run!(command)

          next if command_result.success?

          puts command_result.text_output
          raise Errors::ActionFailed, "tests failed"
        end

        BashCommand.silent_run!("git notes --ref=gotsha add -f -m 'ok'")

        "tests passed"
      end
    end
  end
end
