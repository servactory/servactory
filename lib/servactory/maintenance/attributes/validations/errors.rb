# frozen_string_literal: true

module Servactory
  module Maintenance
    module Attributes
      module Validations
        class Errors
          # TODO: [SRV-404] Review usage after validators migration to static methods.
          #       Type class now creates Errors directly in build_errors_from.
          #       Consider if this class needs refactoring for consistency.
          #       See: lib/servactory/maintenance/attributes/validations/type.rb

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
