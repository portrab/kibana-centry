module CentryObservability
  class Configuration
    attr_accessor :log_path, :sensitive_keys, :max_payload_size, :enabled

    def initialize
      @log_path = ENV.fetch("CENTRY_OBSERVABILITY_LOG_PATH", "log/integrations.log")
      @sensitive_keys = %w(token api_key access_token client_secret password authorization)
      @max_payload_size = 10_000 # bytes; payloads/responses above this are gzip+base64 compressed
      @enabled = true
    end
  end
end
