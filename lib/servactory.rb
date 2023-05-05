# frozen_string_literal: true

require "zeitwerk"

require "active_support/core_ext/string"

# require "servactory/support/loader"
# require "servactory/engine"

loader = Zeitwerk::Loader.for_gem
loader.inflector.inflect(
  "dsl" => "DSL"
)
loader.setup

module Servactory
  module_function

  def configuration
    @configuration ||= Servactory::Configuration.new
  end

  def reset
    @configuration = Servactory::Configuration.new
  end

  def configure
    yield(configuration)
  end
end

# require_relative "servactory/exceptions"

# require_relative "servactory/base"
