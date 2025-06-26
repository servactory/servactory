# frozen_string_literal: true

module Servactory
  module Inputs
    module Validations
      class Errors
        extend Forwardable
        def_delegators :@collection, :<<, :to_a

        def initialize(*_args)
          @collection = Set.new
        end
      end
    end
  end
end
