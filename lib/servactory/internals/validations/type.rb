# frozen_string_literal: true

module Servactory
  module Internals
    module Validations
      class Type < Base
        DEFAULT_MESSAGE = lambda do |service_class_name:, internal:, expected_type:, given_type:|
          I18n.t(
            "servactory.internals.checks.type.default_error",
            service_class_name: service_class_name,
            internal_name: internal.name,
            expected_type: expected_type,
            given_type: given_type
          )
        end

        private_constant :DEFAULT_MESSAGE

        def self.validate!(...)
          new(...).validate!
        end

        ##########################################################################

        def initialize(context:, internal:, value:)
          super()

          @context = context
          @internal = internal
          @value = value
        end

        def validate!
          return unless should_be_checked?

          return if prepared_types.any? { |type| @value.is_a?(type) }

          raise_error_with(
            DEFAULT_MESSAGE,
            service_class_name: @context.class.name,
            internal: @internal,
            expected_type: prepared_types.join(", "),
            given_type: @value.class.name
          )
        end

        private

        def should_be_checked?
          true
        end

        def prepared_types
          @prepared_types ||=
            Array(@internal.types).map do |type|
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
