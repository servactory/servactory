# frozen_string_literal: true

require "zeitwerk"
require "forwardable"
require "servactory"

loader = Zeitwerk::Loader.new
loader.push_dir(File.expand_path("../examples", __dir__))
loader.setup

Dir[File.join(__dir__, "support", "**", "*.rb")].each { |file| require file }

I18n.load_path += Dir["#{File.expand_path('config/locales')}/*.yml"]

# FIXME
RSpec::Expectations.configuration.on_potential_false_positives = :nothing

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect

    # Configures the maximum character length that RSpec will print while
    # formatting an object. You can set length to nil to prevent RSpec from
    # doing truncation.
    c.max_formatted_output_length = nil
  end

  config.include Servactory::TestKit::Rspec::Helpers, type: :service
  config.include Servactory::TestKit::Rspec::Matchers, type: :service
end
