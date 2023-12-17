# frozen_string_literal: true

module Servactory
  module Inputs
    module Validations
      class Type < Base
        def self.check(context:, input:, value:, check_key:, **)
          return unless should_be_checked_for?(input, value, check_key)

          new(context: context, input: input, value: value).check
        end

        def self.should_be_checked_for?(input, value, check_key) # rubocop:disable Metrics/CyclomaticComplexity
          return true if input.internal? || input.output?

          check_key == :types && (
            input.required? || (
              input.optional? && !input.default.nil?
            ) || (
              input.optional? && !value.nil?
            )
          )
        end

        def initialize(context:, input:, value:)
          super()

          @context = context
          @input = input
          @value = value
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
          @prepared_value ||= if @input.input? && @input.optional? && !@input.default.nil? && @value.blank?
                                @input.default
                              else
                                @value
                              end
        end
      end
    end
  end
end
