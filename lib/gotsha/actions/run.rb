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
        raise(Errors::ActionFailed, "tests failed") unless tests_result.success?

        BashCommand.run!("git notes --ref=gotsha add -f -m 'ok'")

        "tests passed"
      rescue Errno::ENOENT
        raise Errors::ActionFailed, "config files not found, please run `bundle exec gotsha init` first"
      end
    end
  end
end
