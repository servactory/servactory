# frozen_string_literal: true

# require "zeitwerk"

require "active_support/all"

require "uri"

# loader = Zeitwerk::Loader.for_gem
# loader.ignore("#{__dir__}/generators")
# loader.ignore("#{__dir__}/servactory/test_kit/rspec")
# loader.inflector.inflect(
#   "dsl" => "DSL"
# )
# loader.setup

require_relative "servactory/support/loader"

module Servactory
  class << self
    def configuration(domain)
      @configuration ||= Configuration.new(domain)
    end

    def configure(domain = :application)
      yield(configuration(domain)) if block_given?
    end

    def reset_configuration!(domain = :application)
      @configuration = Configuration.new(domain)
    end
  end
end

require "servactory/engine" if defined?(Rails::Engine)
