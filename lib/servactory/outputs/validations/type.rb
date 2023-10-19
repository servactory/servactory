# frozen_string_literal: true

module Servactory
  module Outputs
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

        def initialize(context:, output:, value:)
          super()

          @context = context
          @output = output
          @value = value
        end

        def validate!
          Servactory::Maintenance::Validations::Types.validate!(
            context: @context,
            attribute: @output,
            types: @output.types,
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
