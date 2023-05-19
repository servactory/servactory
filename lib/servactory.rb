# frozen_string_literal: true

require "zeitwerk"

require "active_support/core_ext/string"

# require "servactory/support/loader"

loader = Zeitwerk::Loader.for_gem
loader.inflector.inflect(
  "dsl" => "DSL"
)
loader.setup

module Servactory
  module_function

  def configuration
    @configuration ||= Servactory::Configuration::Setup.new
  end

  def reset
    @configuration = Servactory::Configuration::Setup.new
  end

  def configure
    yield(configuration)
  end
end

require "servactory/engine" if defined?(Rails::Engine)

# require_relative "servactory/exceptions"

# require_relative "servactory/base"
