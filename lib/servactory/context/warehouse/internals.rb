# frozen_string_literal: true

module Servactory
  module Context
    module Warehouse
      class Internals
        def initialize(arguments = {})
          @arguments = arguments
        end

        # def names
        #   @arguments.keys
        # end

        def fetch(name, default_value)
          @arguments.fetch(name, default_value)
        end

        def assign(key, value)
          @arguments[key] = value
        end
      end
    end
  end
end