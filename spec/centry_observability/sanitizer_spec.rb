require "spec_helper"

RSpec.describe CentryObservability::Sanitizer do
  subject(:sanitizer) { described_class.new(%w(token api_key)) }

  it "masks sensitive keys at the top level" do
    result = sanitizer.sanitize("token" => "secret", "endpoint" => "/products")
    expect(result["token"]).to eq("[FILTERED]")
    expect(result["endpoint"]).to eq("/products")
  end

  it "masks sensitive keys inside nested structures" do
    result = sanitizer.sanitize("auth" => { "api_key" => "abc123" })
    expect(result["auth"]["api_key"]).to eq("[FILTERED]")
  end

  it "sanitizes hashes inside arrays" do
    result = sanitizer.sanitize([{ "token" => "secret" }])
    expect(result.first["token"]).to eq("[FILTERED]")
  end

  it "is case-insensitive on key matching" do
    result = sanitizer.sanitize("TOKEN" => "secret")
    expect(result["TOKEN"]).to eq("[FILTERED]")
  end
end
