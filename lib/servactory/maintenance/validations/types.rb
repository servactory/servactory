# frozen_string_literal: true

module Servactory
  module Maintenance
    module Validations
      class Types # rubocop:disable Metrics/ClassLength
        DEFAULT_MESSAGE = lambda do | # rubocop:disable Metrics/BlockLength
          service_class_name:,
          attribute_system_name:,
          attribute:,
          value:,
          key_name:,
          expected_type:,
          given_type:
        | # do
          if attribute.collection_mode?
            collection_message = attribute.consists_of.fetch(:message)

            if collection_message.is_a?(Proc)
              collection_message.call(
                "#{attribute_system_name}_name": attribute.name,
                expected_type: expected_type,
                given_type: given_type
              )
            elsif collection_message.is_a?(String) && collection_message.present?
              collection_message
            elsif value.is_a?(attribute.types.fetch(0, Array))
              I18n.t(
                "servactory.#{attribute_system_name.to_s.pluralize}.checks.type.default_error.for_collection.wrong_element_type", # rubocop:disable Layout/LineLength
                service_class_name: service_class_name,
                "#{attribute_system_name}_name": attribute.name,
                expected_type: expected_type,
                given_type: given_type
              )
            else
              I18n.t(
                "servactory.#{attribute_system_name.to_s.pluralize}.checks.type.default_error.for_collection.wrong_type", # rubocop:disable Layout/LineLength
                service_class_name: service_class_name,
                "#{attribute_system_name}_name": attribute.name,
                expected_type: attribute.types.fetch(0, Array),
                given_type: value.class.name
              )
            end
          elsif attribute.hash_mode? && key_name.present?
            hash_message = attribute.schema.fetch(:message)

            if hash_message.is_a?(Proc)
              hash_message.call(
                "#{attribute_system_name}_name": attribute.name,
                key_name: key_name,
                expected_type: expected_type,
                given_type: given_type
              )
            elsif hash_message.is_a?(String) && hash_message.present?
              hash_message
            else
              I18n.t(
                "servactory.#{attribute_system_name.to_s.pluralize}.checks.type.default_error.for_hash.wrong_element_type", # rubocop:disable Layout/LineLength
                service_class_name: service_class_name,
                "#{attribute_system_name}_name": attribute.name,
                key_name: key_name,
                expected_type: expected_type,
                given_type: given_type
              )
            end
          else
            I18n.t(
              "servactory.#{attribute_system_name.to_s.pluralize}.checks.type.default_error.default",
              service_class_name: service_class_name,
              "#{attribute_system_name}_name": attribute.name,
              expected_type: expected_type,
              given_type: given_type
            )
          end
        end

        private_constant :DEFAULT_MESSAGE

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
          collection_validator = nil
          object_schema_validator = nil

          if @attribute.collection_mode?
            collection_validator = Servactory::Maintenance::Validations::Collection.validate(
              types: @types,
              value: @value,
              consists_of: @attribute.consists_of
            )

            return if collection_validator.valid?
          elsif @attribute.hash_mode?
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

          if (first_error = collection_validator&.errors&.first).present?
            return @error_callback.call(
              message: DEFAULT_MESSAGE,
              service_class_name: @context.class.name,
              attribute_system_name: attribute_system_name,
              attribute: @attribute,
              value: @value,
              key_name: nil,
              expected_type: first_error.fetch(:expected_type),
              given_type: first_error.fetch(:given_type)
            )
          end

          if (first_error = object_schema_validator&.errors&.first).present?
            return @error_callback.call(
              message: DEFAULT_MESSAGE,
              service_class_name: @context.class.name,
              attribute_system_name: attribute_system_name,
              attribute: @attribute,
              value: @value,
              key_name: first_error.fetch(:key_name),
              expected_type: first_error.fetch(:expected_type),
              given_type: first_error.fetch(:given_type)
            )
          end

          @error_callback.call(
            message: DEFAULT_MESSAGE,
            service_class_name: @context.class.name,
            attribute_system_name: attribute_system_name,
            attribute: @attribute,
            value: @value,
            key_name: nil,
            expected_type: prepared_types.join(", "),
            given_type: @value.class.name
          )
        end

        private

        def attribute_system_name
          @attribute.class.name.demodulize.downcase.to_sym
        end

        def prepared_types
          @prepared_types ||=
            if @attribute.collection_mode?
              prepared_types_from(Array(@attribute.consists_of.fetch(:type, [])))
            else
              prepared_types_from(@types)
            end
        end

        def prepared_types_from(types)
          types.map do |type|
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
