# frozen_string_literal: true

require "fileutils"

RSpec.describe Gotsha::CLI do
  describe "init" do
    it "sets up .gotsha/commands file" do
      expect(FileUtils).to receive(:mkdir_p).with(".gotsha")
      expect(FileUtils).to receive(:touch).with(".gotsha/commands")

      described_class.call(:init)
    end
  end

  describe "without any action passed" do
    it "calls `run`" do
      expect_any_instance_of(described_class).to receive(:run)

      described_class.call
    end
  end

  describe "run" do
    context "without test command configured" do
      before do
        expect(File)
          .to receive(:exist?).with(Gotsha::COMMANDS_FILE)
          .and_return(false)
      end

      it "fails with proper error" do
        expect do
          described_class.call(:run)
        end.to raise_exception(Gotsha::NoCommandConfigured)
      end
    end

    context "with a test command configured" do
      let(:test_command) { "rails t" }
      let(:sha) { 'test-sha' }

      before do
        expect(File)
          .to receive(:exist?).with(Gotsha::COMMANDS_FILE)
          .and_return(true)

        expect(File)
          .to receive(:read).with(Gotsha::COMMANDS_FILE)
          .and_return(test_command)
      end

      it "runs the command" do
        allow_any_instance_of(described_class)
          .to receive(:last_commit_sha)
          .and_return(sha)

        expect(Kernel).to receive(:system).with(test_command).and_return(true)
        expect(File).to receive(:write).with(Gotsha::LAST_SUCCESS_FILE, sha)

        described_class.call(:run)
      end
    end
  end
end
