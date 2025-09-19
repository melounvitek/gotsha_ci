# frozen_string_literal: true

module Gotsha
  module Actions
    class Run
      def call
        commands = Array(Gotsha::Config::USER_CONFIG.fetch("commands")).join(" && ")

        if commands.empty?
          raise(Errors::ActionFailed,
                "please, define some test commands in `.gotsha/config.yml`")
        end

        tests_result = BashCommand.run!(commands)

        if tests_result.success?
          BashCommand.silent_run!("git notes --ref=gotsha add -f -m 'ok'")

          "tests passed"
        else
          puts tests_result.text_output
          raise Errors::ActionFailed, "tests failed"
        end
      rescue Errno::ENOENT
        raise Errors::ActionFailed, "config files not found, please run `bundle exec gotsha init` first"
      end
    end
  end
end
