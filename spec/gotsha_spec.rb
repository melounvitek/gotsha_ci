# frozen_string_literal: true

require "fileutils"

RSpec.describe Gotsha::CLI do
  describe "#init" do
    it "sets up .gotsha/commands file" do
      expect(FileUtils).to receive(:mkdir_p).with(".gotsha")
      expect(FileUtils).to receive(:touch).with(".gotsha/commands")

      described_class.call("init")
    end
  end
end
