module CentryObservability
  # Masks sensitive keys (tokens, api_keys, ...) before any payload is persisted or shipped.
  class Sanitizer
    MASK = "[FILTERED]".freeze

    def initialize(sensitive_keys)
      @sensitive_keys = sensitive_keys.map { |key| key.to_s.downcase }
    end

    def sanitize(value)
      case value
      when Hash
        value.each_with_object({}) do |(key, val), memo|
          memo[key] = sensitive?(key) ? MASK : sanitize(val)
        end
      when Array
        value.map { |item| sanitize(item) }
      else
        value
      end
    end

    private

    def sensitive?(key)
      @sensitive_keys.include?(key.to_s.downcase)
    end
  end
end
