# frozen_string_literal: true

module Servactory
  module Inputs
    module Validations
      class Type < Base # rubocop:disable Metrics/ClassLength
        DEFAULT_MESSAGE = lambda do |service_class_name:, input:, key_name:, expected_type:, given_type:| # rubocop:disable Metrics/BlockLength
          if input.collection_mode?
            collection_message = input.consists_of.fetch(:message)

            if collection_message.is_a?(Proc)
              collection_message.call(input: input, expected_type: expected_type)
            elsif collection_message.is_a?(String) && collection_message.present?
              collection_message
            else
              I18n.t(
                "servactory.inputs.checks.type.default_error.for_collection.wrong_element_type",
                service_class_name: service_class_name,
                input_name: input.name,
                expected_type: expected_type,
                given_type: given_type
              )
            end
          elsif input.hash_mode? && key_name.present?
            I18n.t(
              "servactory.inputs.checks.type.default_error.for_hash.wrong_element_type",
              service_class_name: service_class_name,
              input_name: input.name,
              key_name: key_name,
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

        def self.check(context:, input:, check_key:, **)
          return unless should_be_checked_for?(input, check_key)

          new(context: context, input: input).check
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

        def initialize(context:, input:)
          super()

          @context = context
          @input = input
        end

        def check
          Servactory::Maintenance::Validations::Types.validate!(
            attribute: @input,
            types: prepared_types,
            value: prepared_value,
            default_object_error: ->(error) { add_default_object_error_with(error) },
            default_error: -> { add_default_error }
          )
        end

        private

        def prepared_types
          @prepared_types ||= Servactory::Maintenance::Validations::Types.prepare!(
            attribute: @input,
            types: @input.types
          )
        end

        def prepared_value
          @prepared_value ||= if @input.optional? && !@input.default.nil? && @input.value.blank?
                                @input.default
                              else
                                @input.value
                              end
        end

        ########################################################################

        def add_default_object_error_with(error)
          add_error(
            DEFAULT_MESSAGE,
            service_class_name: @context.class.name,
            input: @input,
            key_name: error.fetch(:name),
            expected_type: error.fetch(:expected_type),
            given_type: error.fetch(:given_type)
          )
        end

        def add_default_error
          add_error(
            DEFAULT_MESSAGE,
            service_class_name: @context.class.name,
            input: @input,
            key_name: nil,
            expected_type: prepared_types.join(", "),
            given_type: prepared_value.class.name
          )
        end
      end
    end
  end
end
