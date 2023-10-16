# frozen_string_literal: true

module Servactory
  module Outputs
    module Validations
      class Type < Base
        DEFAULT_MESSAGE = lambda do |service_class_name:, output:, value:, key_name:, expected_type:, given_type:| # rubocop:disable Metrics/BlockLength
          if output.collection_mode?
            collection_message = output.consists_of.fetch(:message)

            if collection_message.is_a?(Proc)
              collection_message.call(output: output, expected_type: expected_type)
            elsif collection_message.is_a?(String) && collection_message.present?
              collection_message
            elsif value.is_a?(output.types.fetch(0, Array))
              I18n.t(
                "servactory.outputs.checks.type.default_error.for_collection.wrong_element_type",
                service_class_name: service_class_name,
                output_name: output.name,
                expected_type: expected_type,
                given_type: given_type
              )
            else
              I18n.t(
                "servactory.outputs.checks.type.default_error.for_collection.wrong_type",
                service_class_name: service_class_name,
                output_name: output.name,
                expected_type: output.types.fetch(0, Array),
                given_type: value.class.name
              )
            end
          elsif output.hash_mode? && key_name.present?
            I18n.t(
              "servactory.outputs.checks.type.default_error.for_hash.wrong_element_type",
              service_class_name: service_class_name,
              output_name: output.name,
              key_name: key_name,
              expected_type: expected_type,
              given_type: given_type
            )
          else
            I18n.t(
              "servactory.outputs.checks.type.default_error.default",
              service_class_name: service_class_name,
              output_name: output.name,
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

        def initialize(context:, output:, value:)
          super()

          @context = context
          @output = output
          @value = value
        end

        def validate! # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
          object_schema_validator = nil

          return if prepared_types.any? do |type|
            if @output.collection_mode?
              @value.is_a?(@output.types.fetch(0, Array)) &&
              @value.respond_to?(:all?) && @value.all?(type)
            elsif @output.hash_mode?
              object_schema_validator = Servactory::Maintenance::Validations::ObjectSchema.validate(
                object: @value,
                schema: @output.schema
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
            if @output.collection_mode?
              prepared_types_from(Array(@output.consists_of.fetch(:type, [])))
            else
              prepared_types_from(@output.types)
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
            output: @output,
            value: @value,
            key_name: error.fetch(:name),
            expected_type: error.fetch(:expected_type),
            given_type: error.fetch(:given_type)
          )
        end

        def raise_default_error
          raise_error_with(
            DEFAULT_MESSAGE,
            service_class_name: @context.class.name,
            output: @output,
            value: @value,
            key_name: nil,
            expected_type: prepared_types.join(", "),
            given_type: @value.class.name
          )
        end
      end
    end
  end
end
