# frozen_string_literal: true

require "zeitwerk"

require "active_support/core_ext/string"

loader = Zeitwerk::Loader.for_gem
loader.inflector.inflect(
  "dsl" => "DSL"
)
loader.setup

module Servactory; end

require "servactory/engine" if defined?(Rails::Engine)
