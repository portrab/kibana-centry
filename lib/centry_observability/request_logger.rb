module CentryObservability
  # Wraps an outbound call to a marketplace/integration and records the
  # minimum structured fields required for support/dev investigation.
  #
  # Usage:
  #
  #   context = {
  #     marketplace: "falabella",
  #     endpoint: url,
  #     http_method: "POST",
  #     company_id: company.id,
  #     integration_config_id: integration_config.id,
  #     product_id: product.id,
  #     worker: (self.class.name if respond_to?(:jid)),
  #     payload: request_body
  #   }
  #
  #   response = CentryObservability.request_logger.track(context) do
  #     resp = HTTPClient.post(url, request_body, headers)
  #     context[:http_status] = resp.status
  #     context[:response_body] = resp.body
  #     resp
  #   end
  #
  # The block is expected to set :http_status and :response_body on the same
  # context hash before returning, since the response shape varies by HTTP
  # client (Faraday, Net::HTTP, RestClient, ...).
  class RequestLogger
    def initialize(configuration: CentryObservability.configuration, writer: CentryObservability.writer)
      @configuration = configuration
      @sanitizer = Sanitizer.new(configuration.sensitive_keys)
      @compressor = PayloadCompressor.new(configuration.max_payload_size)
      @writer = writer
    end

    def track(context)
      return yield unless @configuration.enabled

      started_at = Time.now
      begin
        response = yield
        record(context, error: nil, duration_ms: elapsed_ms(started_at))
        response
      rescue StandardError => e
        record(context, error: e, duration_ms: elapsed_ms(started_at))
        raise
      end
    end

    private

    def elapsed_ms(started_at)
      ((Time.now - started_at) * 1000).round(2)
    end

    def record(context, error:, duration_ms:)
      event = {
        occurred_at: Time.now.utc.iso8601,
        event_type: "integration_request",
        marketplace: context[:marketplace],
        endpoint: context[:endpoint],
        http_method: context[:http_method],
        http_status: context[:http_status],
        company_id: context[:company_id],
        integration_config_id: context[:integration_config_id],
        product_id: context[:product_id],
        worker: context[:worker],
        duration_ms: duration_ms,
        payload: sanitized_payload(context[:payload]),
        response: sanitized_payload(context[:response_body]),
        error: error && error.message
      }

      @writer.enqueue(event)
    rescue StandardError
      nil
    end

    def sanitized_payload(raw)
      return nil if raw.nil?

      @compressor.process(@sanitizer.sanitize(raw))
    end
  end
end
