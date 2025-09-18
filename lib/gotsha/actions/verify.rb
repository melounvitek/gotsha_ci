# frozen_string_literal: true

module Gotsha
  module Actions
    class Verify
      def call
        raise(Errors::ActionFailed, "not verified yet") unless last_comment_note == "ok"

        "tests passed"
      end

      private

      def last_comment_note
        `git notes --ref=gotsha show #{last_commit_sha} 2>/dev/null`.strip
      end

      def last_commit_sha
        `git rev-parse HEAD`.strip
      end
    end
  end
end
