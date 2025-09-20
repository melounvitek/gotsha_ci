# frozen_string_literal: true

module Gotsha
  module Actions
    class Run
      def initialize
        @tests_text_outputs = []
      end

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
        commands.each do |command|
          puts "Running `#{command}`..."

          command_result = BashCommand.run!(command)

          @tests_text_outputs << command_result.text_output

          next if command_result.success?

          puts command_result.text_output
          raise Errors::ActionFailed, "tests failed"
        end
      end

      def create_git_note!
        # TODO: use `@tests_text_outputs` to store it somehow in Git note
        BashCommand.silent_run!("git notes --ref=gotsha add -f -m 'ok'")
      end

      def commands
        @commands ||= Array(Gotsha::Config::USER_CONFIG.fetch("commands"))
      end
    end
  end
end
