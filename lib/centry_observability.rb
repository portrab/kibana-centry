require "centry_observability/version"
require "centry_observability/configuration"
require "centry_observability/sanitizer"
require "centry_observability/payload_compressor"
require "centry_observability/log_writer"
require "centry_observability/request_logger"
require "centry_observability/sidekiq_server_middleware"

module CentryObservability
  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end

    def writer
      @writer ||= LogWriter.new(configuration.log_path)
    end

    def request_logger
      @request_logger ||= RequestLogger.new
    end
  end
end
