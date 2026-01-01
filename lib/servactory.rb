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

# Eager load DSL to initialize Stroma::Registry.
# Registry must be populated before any service class is defined.
require_relative "servactory/dsl"

module Servactory; end

require "servactory/engine" if defined?(Rails::Engine)
