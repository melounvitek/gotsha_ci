# frozen_string_literal: true

module Gotsha
  module Actions
    class Run
      def call
        ensure_commands_defined!

        run_commands!
        create_git_note!

        "tests passed"
      end

      private

      def ensure_commands_defined!
        return if commands.any?

        raise(Errors::ActionFailed,
              "please, define some test commands in `.gotsha/config.yml`")
      end

      def run_commands!
        commands.map do |command|
          puts "Running `#{command}`..."

          command_result = BashCommand.run!(command)

          if command_result.success?
            command_result.text_output
          else
            puts command_result.text_output
            raise Errors::ActionFailed, "tests failed"
          end
        end
      end

      def create_git_note!
        BashCommand.silent_run!("git notes --ref=gotsha add -f -m 'ok'")
      end

      def commands
        @commands ||= Array(Gotsha::Config::USER_CONFIG.fetch("commands"))
      end
    end
  end
end
