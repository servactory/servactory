# frozen_string_literal: true

module Servactory
  module Inputs
    module Validations
      class Errors
        # TODO: [SRV-404] Review usage after validators migration to static methods.
        #       Consider consolidating with maintenance/attributes/validations/Errors.
        #       See: lib/servactory/maintenance/attributes/validations/type.rb

        extend Forwardable

        def_delegators :@collection, :<<, :to_a

        def initialize(*)
          @collection = Set.new
        end
      end
    end
  end
end
