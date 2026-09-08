require "zlib"
require "stringio"
require "base64"
require "json"

module CentryObservability
  # Compresses payloads/responses above a configured size threshold, so large
  # bodies don't blow up log volume or storage/retention costs.
  class PayloadCompressor
    def initialize(max_size)
      @max_size = max_size
    end

    def process(payload)
      raw = payload.is_a?(String) ? payload : payload.to_json
      return { data: payload, compressed: false } if raw.bytesize <= @max_size

      { data: compress(raw), compressed: true }
    rescue StandardError
      { data: nil, compressed: false }
    end

    private

    def compress(raw)
      io = StringIO.new
      gz = Zlib::GzipWriter.new(io)
      gz.write(raw)
      gz.close
      Base64.strict_encode64(io.string)
    end
  end
end
