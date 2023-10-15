# frozen_string_literal: true

module Servactory
  module Internals
    module Validations
      class Type < Base
        DEFAULT_MESSAGE = lambda do |service_class_name:, internal:, value:, object_name:, expected_type:, given_type:| # rubocop:disable Metrics/BlockLength
          if internal.collection_mode?
            collection_message = internal.consists_of.fetch(:message)

            if collection_message.is_a?(Proc)
              collection_message.call(internal: internal, expected_type: expected_type)
            elsif collection_message.is_a?(String) && collection_message.present?
              collection_message
            elsif value.is_a?(internal.types.fetch(0, Array))
              I18n.t(
                "servactory.internals.checks.type.default_error.for_collection.wrong_element_type",
                service_class_name: service_class_name,
                internal_name: internal.name,
                expected_type: expected_type,
                given_type: given_type
              )
            else
              I18n.t(
                "servactory.internals.checks.type.default_error.for_collection.wrong_type",
                service_class_name: service_class_name,
                internal_name: internal.name,
                expected_type: internal.types.fetch(0, Array),
                given_type: value.class.name
              )
            end
          elsif internal.object_mode? && object_name.present?
            I18n.t(
              "servactory.internals.checks.type.default_error.for_object.wrong_element_type",
              service_class_name: service_class_name,
              internal_name: internal.name,
              object_name: object_name,
              expected_type: expected_type,
              given_type: given_type
            )
          else
            I18n.t(
              "servactory.internals.checks.type.default_error.default",
              service_class_name: service_class_name,
              internal_name: internal.name,
              expected_type: expected_type,
              given_type: given_type
            )
          end
        end

        private_constant :DEFAULT_MESSAGE

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

        def validate! # rubocop:disable Metrics/MethodLength, Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
          object_schema_validator = nil

          return if prepared_types.any? do |type|
            if @internal.collection_mode?
              @value.is_a?(@internal.types.fetch(0, Array)) &&
              @value.respond_to?(:all?) && @value.all?(type)
            elsif @internal.object_mode?
              object_schema_validator = Servactory::Maintenance::Validations::ObjectSchema.validate(
                object: @value,
                schema: @internal.schema
              )

              object_schema_validator.valid?
            else
              @value.is_a?(type)
            end
          end

          if (first_error = object_schema_validator&.errors&.first).present?
            raise_default_object_error_with(first_error)
          end

          raise_default_error
        end

        private

        def prepared_types
          @prepared_types ||=
            if @internal.collection_mode?
              prepared_types_from(Array(@internal.consists_of.fetch(:type, [])))
            else
              prepared_types_from(@internal.types)
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

        ########################################################################

        def raise_default_object_error_with(error)
          raise_error_with(
            DEFAULT_MESSAGE,
            service_class_name: @context.class.name,
            internal: @internal,
            value: @value,
            object_name: error.fetch(:name),
            expected_type: error.fetch(:expected_type),
            given_type: error.fetch(:given_type)
          )
        end

        def raise_default_error
          raise_error_with(
            DEFAULT_MESSAGE,
            service_class_name: @context.class.name,
            internal: @internal,
            value: @value,
            object_name: nil,
            expected_type: prepared_types.join(", "),
            given_type: @value.class.name
          )
        end
      end
    end
  end
end
