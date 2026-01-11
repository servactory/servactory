# frozen_string_literal: true

module Servactory
  module Maintenance
    module Attributes
      module Validations
        class Errors
          extend Forwardable

          def_delegators :@collection, :<<, :to_a, :empty?

          def initialize(*)
            @collection = Set.new
          end
        end
      end
    end
  end
end
