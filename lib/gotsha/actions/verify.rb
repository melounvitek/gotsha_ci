# frozen_string_literal: true

module Gotsha
  module Actions
    class Verify
      def call
        last_commit_sha = BashCommand.run!("git rev-parse HEAD").text_output.strip
        last_comment_note = BashCommand.run!("git notes --ref=gotsha show #{last_commit_sha}").text_output.strip

        raise(Errors::HardFail, "not verified yet") unless last_comment_note == "ok"

        "tests passed"
      end
    end
  end
end
