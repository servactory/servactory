# frozen_string_literal: true

module Servactory
  module Maintenance
    module Validations
      class Types
        def self.validate!(...)
          new(...).validate!
        end

        def initialize(context:, attribute:, types:, value:, error_callback:)
          @context = context
          @attribute = attribute
          @types = types
          @value = value
          @error_callback = error_callback
        end

        def validate! # rubocop:disable Metrics/MethodLength
          return if prepared_types.any? do |type|
            @value.is_a?(type)
          end

          @error_callback.call(
            message: Servactory::Maintenance::Attributes::Translator::Type.default_message,
            service: @context.send(:servactory_service_info),
            attribute: @attribute,
            value: @value,
            key_name: nil,
            expected_type: prepared_types.join(", "),
            given_type: @value.class.name
          )
        end

        private

        def prepared_types
          @prepared_types ||= prepared_types_from(@types)
        end

        def prepared_types_from(types)
          types.map do |type|
            Servactory::Utils.constantize_class(type)
          end
        end
      end
    end
  end
end
