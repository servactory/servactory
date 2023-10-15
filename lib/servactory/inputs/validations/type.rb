# frozen_string_literal: true

module Servactory
  module Inputs
    module Validations
      class Type < Base # rubocop:disable Metrics/ClassLength
        DEFAULT_MESSAGE = lambda do |service_class_name:, input:, object_name:, expected_type:, given_type:| # rubocop:disable Metrics/BlockLength
          if input.collection_mode?
            collection_message = input.consists_of.fetch(:message)

            if collection_message.is_a?(Proc)
              collection_message.call(input: input, expected_type: expected_type)
            elsif collection_message.is_a?(String) && collection_message.present?
              collection_message
            else
              I18n.t(
                "servactory.inputs.checks.type.default_error.for_collection",
                service_class_name: service_class_name,
                input_name: input.name,
                expected_type: expected_type,
                given_type: given_type
              )
            end
          elsif input.object_mode? && object_name.present?
            I18n.t(
              "servactory.inputs.checks.type.default_error.for_object.wrong_element_type",
              service_class_name: service_class_name,
              input_name: input.name,
              object_name: object_name,
              expected_type: expected_type,
              given_type: given_type
            )
          else
            I18n.t(
              "servactory.inputs.checks.type.default_error.default",
              service_class_name: service_class_name,
              input_name: input.name,
              expected_type: expected_type,
              given_type: given_type
            )
          end
        end

        private_constant :DEFAULT_MESSAGE

        def self.check(context:, input:, check_key:, check_options:)
          return unless should_be_checked_for?(input, check_key)

          new(context: context, input: input, types: check_options).check
        end

        def self.should_be_checked_for?(input, check_key)
          check_key == :types && (
            input.required? || (
              input.optional? && !input.default.nil?
            ) || (
              input.optional? && !input.value.nil?
            )
          )
        end

        ##########################################################################

        def initialize(context:, input:, types:)
          super()

          @context = context
          @input = input
          @types = types
        end

        def check # rubocop:disable Metrics/MethodLength, Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
          object_schema_validator = nil

          return if prepared_types.any? do |type|
            if @input.collection_mode?
              prepared_value.is_a?(@types.fetch(0, Array)) &&
              prepared_value.respond_to?(:all?) && prepared_value.all?(type)
            elsif @input.object_mode?
              object_schema_validator = Servactory::Maintenance::Validations::ObjectSchema.validate(
                object: prepared_value,
                schema: @input.schema
              )

              object_schema_validator.valid?
            else
              prepared_value.is_a?(type)
            end
          end

          if (first_error = object_schema_validator&.errors&.first).present?
            return add_default_object_error_with(first_error)
          end

          add_default_error
        end

        ########################################################################

        def prepared_types
          @prepared_types ||=
            if @input.collection_mode?
              prepared_types_from(Array(@input.consists_of.fetch(:type, [])))
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

        def prepared_value
          @prepared_value ||= if @input.optional? && !@input.default.nil? && @input.value.blank?
                                @input.default
                              else
                                @input.value
                              end
        end

        private

        def add_default_object_error_with(error)
          add_error(
            DEFAULT_MESSAGE,
            service_class_name: @context.class.name,
            input: @input,
            object_name: error.fetch(:name),
            expected_type: error.fetch(:expected_type),
            given_type: error.fetch(:given_type)
          )
        end

        def add_default_error
          add_error(
            DEFAULT_MESSAGE,
            service_class_name: @context.class.name,
            input: @input,
            object_name: nil,
            expected_type: prepared_types.join(", "),
            given_type: prepared_value.class.name
          )
        end
      end
    end
  end
end
