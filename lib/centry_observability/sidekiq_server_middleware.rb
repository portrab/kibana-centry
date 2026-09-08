module CentryObservability
  # Sidekiq server middleware: records worker execution outcome (success,
  # failure, duration) so dead/failing workers are visible without needing
  # access to the Sidekiq morgue in production.
  #
  # Usage (config/initializers/sidekiq.rb):
  #
  #   Sidekiq.configure_server do |config|
  #     config.server_middleware do |chain|
  #       chain.add CentryObservability::SidekiqServerMiddleware
  #     end
  #   end
  class SidekiqServerMiddleware
    def call(worker, job, queue)
      return yield unless CentryObservability.configuration.enabled

      started_at = Time.now
      error = nil
      begin
        yield
      rescue StandardError => e
        error = e
        raise
      ensure
        record(worker, job, queue, error, elapsed_ms(started_at))
      end
    end

    private

    def elapsed_ms(started_at)
      ((Time.now - started_at) * 1000).round(2)
    end

    def record(worker, job, queue, error, duration_ms)
      event = {
        occurred_at: Time.now.utc.iso8601,
        event_type: "worker_execution",
        worker: worker.class.name,
        queue: queue,
        job_id: job["jid"],
        company_id: job["company_id"],
        duration_ms: duration_ms,
        status: error ? "failed" : "success",
        error: error && error.message
      }

      CentryObservability.writer.enqueue(event)
    rescue StandardError
      nil
    end
  end
end
