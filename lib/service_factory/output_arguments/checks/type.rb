# frozen_string_literal: true

module ServiceFactory
  module OutputArguments
    module Checks
      class Type < Base
        DEFAULT_MESSAGE = lambda do |service_class_name:, output_argument:, expected_type:, given_type:|
          "The \"#{output_argument.name}\" output argument on \"#{service_class_name}\" must be of type " \
            "\"#{expected_type}\" but was \"#{given_type}\""
        end

        private_constant :DEFAULT_MESSAGE

        def self.check!(...)
          new(...).check!
        end

        ##########################################################################

        def initialize(context:, output_argument:, value:)
          super()

          @context = context
          @output_argument = output_argument
          @value = value
        end

        def check!
          return if prepared_types.any? { |type| @value.is_a?(type) }

          raise_error_with(
            DEFAULT_MESSAGE,
            service_class_name: @context.class.name,
            output_argument: @output_argument,
            expected_type: prepared_types.join(", "),
            given_type: @value.class.name
          )
        end

        private

        def prepared_types
          @prepared_types ||=
            Array(@output_argument.types).map do |type|
              if type.is_a?(String)
                Object.const_get(type)
              else
                type
              end
            end
        end
      end
    end
  end
end
