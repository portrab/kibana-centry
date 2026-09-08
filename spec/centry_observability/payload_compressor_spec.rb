require "spec_helper"

RSpec.describe CentryObservability::PayloadCompressor do
  subject(:compressor) { described_class.new(10) }

  it "keeps small payloads uncompressed" do
    result = compressor.process("a" => 1)
    expect(result[:compressed]).to eq(false)
  end

  it "compresses payloads above the size threshold" do
    large_payload = { "data" => "x" * 100 }
    result = compressor.process(large_payload)
    expect(result[:compressed]).to eq(true)
    expect(result[:data]).to be_a(String)
  end
end
