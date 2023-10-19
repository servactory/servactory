# frozen_string_literal: true

module Servactory
  module Internals
    module Validations
      class Type < Base
        def self.validate!(...)
          return unless should_be_checked?

          new(...).validate!
        end

        def self.should_be_checked?
          true
        end

        ##########################################################################

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
            error_callback: lambda do |**args|
              raise_error_with(**args)
            end
          )
        end
      end
    end
  end
end
