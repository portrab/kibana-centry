require "json"
require "fileutils"
require "thread"

module CentryObservability
  # Writes events to a local file asynchronously via a background thread, so
  # a slow or failing disk never blocks the Rails request cycle or a Sidekiq
  # worker. This file is the intermediate hand-off point: an external agent
  # (e.g. Filebeat) is responsible for shipping it to Elasticsearch/Kibana.
  #
  # One JSON object per line (newline-delimited JSON), which is what
  # Filebeat's json input expects.
  class LogWriter
    MAX_QUEUE_SIZE = 1000

    def initialize(log_path)
      @log_path = log_path
      @queue = Queue.new
      FileUtils.mkdir_p(File.dirname(log_path))
      start_worker
    end

    def enqueue(event)
      return if @queue.size >= MAX_QUEUE_SIZE

      @queue << event
    rescue StandardError
      nil
    end

    private

    def start_worker
      @thread = Thread.new do
        loop do
          event = @queue.pop
          write(event)
        end
      end
      @thread.abort_on_exception = false
    end

    def write(event)
      File.open(@log_path, "a") { |file| file.puts(event.to_json) }
    rescue StandardError
      nil
    end
  end
end
