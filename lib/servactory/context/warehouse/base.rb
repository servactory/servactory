# frozen_string_literal: true

module Servactory
  module Context
    module Warehouse
      class Base
        def initialize(arguments = {})
          @arguments = arguments
        end

        # def fetch!(name)
        #   @arguments.fetch(name)
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
