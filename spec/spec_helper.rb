$LOAD_PATH.unshift(File.expand_path("../../lib", __FILE__))
require "centry_observability"

RSpec.configure do |config|
  config.example_status_persistence_file_path = ".rspec_status"
  config.disable_monkey_patching!
end
