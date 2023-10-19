# frozen_string_literal: true

module Servactory
  module Inputs
    module Validations
      class Type < Base
        DEFAULT_MESSAGE = lambda do |service_class_name:, attribute:, key_name:, expected_type:, given_type:, **| # rubocop:disable Metrics/BlockLength
          if attribute.collection_mode?
            collection_message = attribute.consists_of.fetch(:message)

            if collection_message.is_a?(Proc)
              collection_message.call(input: attribute, expected_type: expected_type)
            elsif collection_message.is_a?(String) && collection_message.present?
              collection_message
            else
              I18n.t(
                "servactory.inputs.checks.type.default_error.for_collection.wrong_element_type",
                service_class_name: service_class_name,
                input_name: attribute.name,
                expected_type: expected_type,
                given_type: given_type
              )
            end
          elsif attribute.hash_mode? && key_name.present?
            I18n.t(
              "servactory.inputs.checks.type.default_error.for_hash.wrong_element_type",
              service_class_name: service_class_name,
              input_name: attribute.name,
              key_name: key_name,
              expected_type: expected_type,
              given_type: given_type
            )
          else
            I18n.t(
              "servactory.inputs.checks.type.default_error.default",
              service_class_name: service_class_name,
              input_name: attribute.name,
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

        def check # rubocop:disable Metrics/MethodLength
          Servactory::Maintenance::Validations::Types.validate!(
            attribute: @input,
            types: @input.types,
            value: prepared_value,
            error_callback: lambda do |**args|
              add_error(
                DEFAULT_MESSAGE,
                service_class_name: @context.class.name,
                **args
              )
            end
          )
        end

        private

        def prepared_value
          @prepared_value ||= if @input.optional? && !@input.default.nil? && @input.value.blank?
                                @input.default
                              else
                                @input.value
                              end
        end
      end
    end
  end
end
