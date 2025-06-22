# frozen_string_literal: true

module Servactory
  module Inputs
    module Validations
      class Required < Base
        def self.check(context:, attribute:, value:, check_key:, **_options)
          return unless should_be_checked_for?(attribute, check_key)

          new(context:, input: attribute, value:).check
        end

        def self.should_be_checked_for?(input, check_key)
          check_key == :required && input.required?
        end

        ##########################################################################

        def initialize(context:, input:, value:)
          super()

          @context = context
          @input = input
          @value = value
        end

        def check
          return if Servactory::Utils.value_present?(@value)

          _, message = @input.required.values_at(:is, :message)

          add_error_with(message)
        end

        private

        def add_error_with(message)
          add_error(
            message: message.presence || Servactory::Inputs::Translator::Required.default_message,
            service: @context.send(:servactory_service_info),
            input: @input,
            value: @value
          )
        end
      end
    end
  end
end
