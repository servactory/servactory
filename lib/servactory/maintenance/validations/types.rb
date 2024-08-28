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

        def validate! # rubocop:disable Metrics/MethodLength, Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
          object_schema_validator = nil

          if @attribute.hash_mode?
            object_schema_validator = Servactory::Maintenance::Validations::ObjectSchema.validate(
              object: @value,
              schema: @attribute.schema
            )

            return if object_schema_validator.valid?
          else
            return if prepared_types.any? do |type| # rubocop:disable Style/IfInsideElse
              @value.is_a?(type)
            end
          end

          if (first_error = object_schema_validator&.errors&.first).present?
            return @error_callback.call(
              message: Servactory::Maintenance::Attributes::Translator::Type.default_message,
              service: @context.send(:servactory_service_info),
              attribute: @attribute,
              value: @value,
              key_name: first_error.fetch(:key_name),
              expected_type: first_error.fetch(:expected_type),
              given_type: first_error.fetch(:given_type)
            )
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
