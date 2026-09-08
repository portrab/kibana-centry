require "spec_helper"
require "tmpdir"
require "timeout"
require "json"

RSpec.describe CentryObservability::LogWriter do
  it "writes enqueued events to the log file asynchronously" do
    Dir.mktmpdir do |dir|
      log_path = File.join(dir, "integrations.log")
      writer = described_class.new(log_path)

      writer.enqueue("marketplace" => "falabella", "http_status" => 200)

      Timeout.timeout(2) do
        sleep 0.05 until File.exist?(log_path) && !File.read(log_path).empty?
      end

      line = File.read(log_path).lines.first
      expect(JSON.parse(line)["marketplace"]).to eq("falabella")
    end
  end
end
