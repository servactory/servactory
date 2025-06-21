# frozen_string_literal: true

module Servactory
  module Context
    module Warehouse
      class Configuration
        def initialize(context)
          @configuration = Servactory::Configuration::Setup.new(context)
        end

        def method_missing(name, *args, &block)
          @configuration.public_send(name, *args, &block)
        end

        def respond_to_missing?(name, include_private = false)
          @configuration.respond_to?(name, include_private) || super
        end
      end
    end
  end
end
