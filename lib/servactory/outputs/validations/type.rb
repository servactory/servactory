# frozen_string_literal: true

module Servactory
  module Outputs
    module Validations
      class Type < Base
        DEFAULT_MESSAGE = lambda do |service_class_name:, attribute:, value:, key_name:, expected_type:, given_type:| # rubocop:disable Metrics/BlockLength
          if attribute.collection_mode?
            collection_message = attribute.consists_of.fetch(:message)

            if collection_message.is_a?(Proc)
              collection_message.call(output: attribute, expected_type: expected_type)
            elsif collection_message.is_a?(String) && collection_message.present?
              collection_message
            elsif value.is_a?(attribute.types.fetch(0, Array))
              I18n.t(
                "servactory.outputs.checks.type.default_error.for_collection.wrong_element_type",
                service_class_name: service_class_name,
                output_name: attribute.name,
                expected_type: expected_type,
                given_type: given_type
              )
            else
              I18n.t(
                "servactory.outputs.checks.type.default_error.for_collection.wrong_type",
                service_class_name: service_class_name,
                output_name: attribute.name,
                expected_type: attribute.types.fetch(0, Array),
                given_type: value.class.name
              )
            end
          elsif attribute.hash_mode? && key_name.present?
            I18n.t(
              "servactory.outputs.checks.type.default_error.for_hash.wrong_element_type",
              service_class_name: service_class_name,
              output_name: attribute.name,
              key_name: key_name,
              expected_type: expected_type,
              given_type: given_type
            )
          else
            I18n.t(
              "servactory.outputs.checks.type.default_error.default",
              service_class_name: service_class_name,
              output_name: attribute.name,
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

        def validate! # rubocop:disable Metrics/MethodLength
          Servactory::Maintenance::Validations::Types.validate!(
            attribute: @output,
            types: @output.types,
            value: @value,
            error_callback: lambda do |**args|
              raise_error_with(
                DEFAULT_MESSAGE,
                service_class_name: @context.class.name,
                **args
              )
            end
          )
        end
      end
    end
  end
end
