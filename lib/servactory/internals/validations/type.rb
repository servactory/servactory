# frozen_string_literal: true

module Servactory
  module Internals
    module Validations
      class Type < Base
        def self.validate!(...)
          new(...).validate!
        end

        def initialize(context:, internal:, value:)
          super()

          @context = context
          @internal = internal
          @value = value
        end

        def validate!
          Servactory::Maintenance::Validations::Types.validate!(
            context: @context,
            attribute: @internal,
            types: @internal.types,
            value: @value,
            error_callback: ->(**args) { raise_error_with(**args) }
          )
        end
      end
    end
  end
end
