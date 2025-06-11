# frozen_string_literal: true

require "zeitwerk"

require "active_support/all"

require "uri"

loader = Zeitwerk::Loader.for_gem
loader.ignore("#{__dir__}/generators")
loader.ignore("#{__dir__}/servactory/test_kit/rspec")
loader.inflector.inflect(
  "dsl" => "DSL"
)
loader.setup

# Attempt to load the C extension
begin
  require "servactory/servactory"
rescue LoadError
  # C extension is not available, continue with pure Ruby
end

module Servactory; end

require "servactory/engine" if defined?(Rails::Engine)
