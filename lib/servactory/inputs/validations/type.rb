# frozen_string_literal: true

module Servactory
  module Inputs
    module Validations
      class Type < Base
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

        def initialize(context:, input:)
          super()

          @context = context
          @input = input
        end

        def check
          Servactory::Maintenance::Validations::Types.validate!(
            context: @context,
            attribute: @input,
            types: @input.types,
            value: prepared_value,
            error_callback: ->(**args) { add_error(**args) }
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
