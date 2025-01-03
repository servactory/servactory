# frozen_string_literal: true

module Servactory
  module Context
    module Warehouse
      class Internals
        attr_reader :arguments

        def initialize(context, **arguments)
          @context = context
          @arguments = arguments
        end

        def names
          @arguments.keys
        end
      end
    end
  end
end
