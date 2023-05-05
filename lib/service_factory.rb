# frozen_string_literal: true

require "zeitwerk"

require "active_support/core_ext/string"

# require "service_factory/support/loader"
# require "service_factory/engine"

loader = Zeitwerk::Loader.for_gem
loader.inflector.inflect(
  "dsl" => "DSL"
)
loader.setup

module ServiceFactory
  module_function

  def configuration
    @configuration ||= ServiceFactory::Configuration.new
  end

  def reset
    @configuration = ServiceFactory::Configuration.new
  end

  def configure
    yield(configuration)
  end
end

# require_relative "service_factory/exceptions"

# require_relative "service_factory/base"
