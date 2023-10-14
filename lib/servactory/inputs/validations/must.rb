# frozen_string_literal: true

module Servactory
  module Inputs
    module Validations
      class Must < Base
        DEFAULT_MESSAGE = lambda do |service_class_name:, input:, value:, code:|
          I18n.t(
            "servactory.inputs.checks.must.default_error",
            service_class_name: service_class_name,
            input_name: input.name,
            value: value,
            code: code
          )
        end

        SYNTAX_ERROR_MESSAGE = lambda do |service_class_name:, input:, value:, code:, exception_message:|
          I18n.t(
            "servactory.inputs.checks.must.syntax_error",
            service_class_name: service_class_name,
            input_name: input.name,
            value: value,
            code: code,
            exception_message: exception_message
          )
        end

        private_constant :DEFAULT_MESSAGE, :SYNTAX_ERROR_MESSAGE

        def self.check(context:, input:, check_key:, check_options:)
          return unless should_be_checked_for?(input, check_key)

          new(context: context, input: input, check_options: check_options).check
        end

        def self.should_be_checked_for?(input, check_key)
          check_key == :must && input.must_present?
        end

        ##########################################################################

        def initialize(context:, input:, check_options:)
          super()

          @context = context
          @input = input
          @check_options = check_options
        end

        def check
          @check_options.each do |code, options|
            message = call_or_fetch_message_from(code, options)

            next if message.blank?

            add_error_with(message, code)
          end

          errors
        end

        private

        def call_or_fetch_message_from(code, options)
          check, message = options.values_at(:is, :message)

          return if check.call(value: @input.value)

          message.presence || DEFAULT_MESSAGE
        rescue StandardError => e
          add_syntax_error_with(SYNTAX_ERROR_MESSAGE, code, e.message)
        end

        ########################################################################

        def add_error_with(message, code)
          add_error(
            message,
            service_class_name: @context.class.name,
            input: @input,
            value: @input.value,
            code: code
          )
        end

        def add_syntax_error_with(message, code, exception_message)
          add_error(
            message,
            service_class_name: @context.class.name,
            input: @input,
            value: @input.value,
            code: code,
            exception_message: exception_message
          )
        end
      end
    end
  end
end
