# frozen_string_literal: true

module Servactory
  module Inputs
    module Validations
      class Inclusion < Base
        DEFAULT_MESSAGE = lambda do |service_class_name:, input:, value:|
          I18n.t(
            "servactory.inputs.checks.inclusion.default_error",
            service_class_name: service_class_name,
            input_name: input.name,
            input_inclusion: input.inclusion[:in],
            value: value
          )
        end

        private_constant :DEFAULT_MESSAGE

        def self.check(context:, attribute:, check_key:, **)
          return unless should_be_checked_for?(attribute, check_key)

          new(context: context, input: attribute).check
        end

        def self.should_be_checked_for?(input, check_key)
          check_key == :inclusion && (
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
          inclusion_in, message = @input.inclusion.values_at(:in, :message)

          return if inclusion_in.nil?
          return if inclusion_in.include?(@input.value)

          add_error_with(message)
        end

        private

        def add_error_with(message)
          add_error(
            message: message.presence || DEFAULT_MESSAGE,
            service_class_name: @context.class.name,
            input: @input,
            value: @input.value
          )
        end
      end
    end
  end
end
