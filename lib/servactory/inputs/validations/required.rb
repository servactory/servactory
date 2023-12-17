# frozen_string_literal: true

module Servactory
  module Inputs
    module Validations
      class Required < Base
        DEFAULT_MESSAGE = lambda do |service_class_name:, input:, value:|
          i18n_key = "servactory.inputs.checks.required.default_error."
          i18n_key += input.collection_mode? && value.present? ? "for_collection" : "default"

          I18n.t(
            i18n_key,
            service_class_name: service_class_name,
            input_name: input.name
          )
        end

        private_constant :DEFAULT_MESSAGE

        def self.check(context:, attribute:, check_key:, **)
          return unless should_be_checked_for?(attribute, check_key)

          new(context: context, input: attribute).check
        end

        def self.should_be_checked_for?(input, check_key)
          check_key == :required && input.required?
        end

        ##########################################################################

        def initialize(context:, input:)
          super()

          @context = context
          @input = input
        end

        def check
          if @input.collection_mode? && Servactory::Utils.value_present?(@input.value)
            return if @input.value.respond_to?(:all?) && @input.value.all?(&:present?)
          elsif Servactory::Utils.value_present?(@input.value)
            return
          end

          _, message = @input.required.values_at(:is, :message)

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
