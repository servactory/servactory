# frozen_string_literal: true

module Servactory
  module Inputs
    module Validations
      class Required < Base
        def self.check(context:, attribute:, value:, check_key:, **)
          return unless should_be_checked_for?(attribute, check_key)

          new(context: context, input: attribute, value: value).check
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
          if @input.collection_mode? && Servactory::Utils.value_present?(@value)
            return if collection_valid?
          elsif Servactory::Utils.value_present?(@value)
            return
          end

          _, message = @input.required.values_at(:is, :message)

          add_error_with(message)
        end

        private

        def collection_valid?
          collection_valid_for?(values: @value)
        end

        def collection_valid_for?(values:)
          values.respond_to?(:all?) && values.flatten.all?(&:present?)
        end

        def add_error_with(message)
          add_error(
            message: message.presence || Servactory::Inputs::Translator::Required.default_message,
            service_class_name: @context.class.name,
            input: @input,
            value: @value
          )
        end
      end
    end
  end
end
