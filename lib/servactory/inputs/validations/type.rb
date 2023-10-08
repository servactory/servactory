# frozen_string_literal: true

module Servactory
  module Inputs
    module Validations
      class Type < Base
        DEFAULT_MESSAGE = lambda do |service_class_name:, input:, expected_type:, given_type:|
          if input.collection_mode?
            collection_message = input.of.fetch(:message)

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

        def self.check(context:, input:, value:, check_key:, check_options:)
          return unless should_be_checked_for?(input, value, check_key)

          new(context: context, input: input, value: value, types: check_options).check
        end

        def self.should_be_checked_for?(input, value, check_key)
          check_key == :types && (
            input.required? || (
              input.optional? && !input.default.nil?
            ) || (
              input.optional? && !value.nil?
            )
          )
        end

        ##########################################################################

        def initialize(context:, input:, value:, types:)
          super()

          @context = context
          @input = input
          @value = value
          @types = types
        end

        def check # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
          return if prepared_types.any? do |type|
            if @input.collection_mode?
              prepared_value.is_a?(@types.fetch(0, Array)) &&
              prepared_value.respond_to?(:all?) && prepared_value.all?(type)
            else
              prepared_value.is_a?(type)
            end
          end

          add_error(
            DEFAULT_MESSAGE,
            service_class_name: @context.class.name,
            input: @input,
            expected_type: prepared_types.join(", "),
            given_type: prepared_value.class.name
          )
        end

        ########################################################################

        def prepared_types
          @prepared_types ||=
            if @input.collection_mode?
              Array(@input.of.fetch(:type, [])).map do |type|
                if type.is_a?(String)
                  Object.const_get(type)
                else
                  type
                end
              end
            else
              @types.map do |type|
                if type.is_a?(String)
                  Object.const_get(type)
                else
                  type
                end
              end
            end
        end

        def prepared_value
          @prepared_value ||= @input.optional? && !@input.default.nil? && @value.blank? ? @input.default : @value
        end
      end
    end
  end
end
