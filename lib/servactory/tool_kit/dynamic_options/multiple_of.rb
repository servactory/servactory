# frozen_string_literal: true

module Servactory
  module ToolKit
    module DynamicOptions
      # Validates that numeric value is a multiple of a specified number.
      #
      # ## Purpose
      #
      # MultipleOf ensures that numeric values are evenly divisible by
      # a specified divisor. This is useful for validating quantities,
      # prices, or any values that must conform to specific increments.
      #
      # ## Usage
      #
      # This option is **NOT included by default**. Register it for each
      # attribute type where you want to use it:
      #
      # ```ruby
      # configuration do
      #   input_option_helpers([
      #     Servactory::ToolKit::DynamicOptions::MultipleOf.use
      #   ])
      #
      #   internal_option_helpers([
      #     Servactory::ToolKit::DynamicOptions::MultipleOf.use
      #   ])
      #
      #   output_option_helpers([
      #     Servactory::ToolKit::DynamicOptions::MultipleOf.use
      #   ])
      # end
      # ```
      #
      # Use in your service definition:
      #
      # ```ruby
      # class ProcessOrderService < ApplicationService::Base
      #   input :quantity, type: Integer, multiple_of: 5
      #   input :price, type: Float, multiple_of: 0.25
      #   input :batch_size, type: Integer, multiple_of: 100
      # end
      # ```
      #
      # ## Simple Mode
      #
      # Specify divisor directly:
      #
      # ```ruby
      # class ProcessOrderService < ApplicationService::Base
      #   input :quantity, type: Integer, multiple_of: 5
      #   input :price, type: Float, multiple_of: 0.25
      #   input :batch_size, type: Integer, multiple_of: 100
      # end
      # ```
      #
      # ## Advanced Mode
      #
      # Specify divisor with custom error message using a hash:
      #
      # With static message:
      #
      # ```ruby
      # input :quantity, type: Integer, multiple_of: {
      #   is: 5,
      #   message: "Input `quantity` must be a multiple of 5"
      # }
      # ```
      #
      # With dynamic lambda message:
      #
      # ```ruby
      # input :quantity, type: Integer, multiple_of: {
      #   is: 5,
      #   message: lambda do |input:, value:, option_value:, **|
      #     "Input `#{input.name}` must be divisible by #{option_value}, got #{value}"
      #   end
      # }
      # ```
      #
      # Lambda receives the following parameters:
      # - For inputs: `input:, option_value:, value:, **`
      # - For internals: `internal:, option_value:, value:, **`
      # - For outputs: `output:, option_value:, value:, **`
      #
      # ## Supported Types
      #
      # - Integer
      # - Float
      # - Rational
      # - BigDecimal
      #
      # ## Important Notes
      #
      # - Divisor must be a non-zero Numeric
      # - Uses epsilon comparison for floating point precision
      # - Returns false for non-numeric values
      # - Provides specific error messages for blank and zero divisors
      class MultipleOf < Must
        # Creates a MultipleOf validator instance.
        #
        # @param option_name [Symbol] The option name (default: :multiple_of)
        # @return [Servactory::Maintenance::Attributes::OptionHelper]
        def self.use(option_name = :multiple_of)
          new(option_name).must(:be_multiple_of)
        end

        # Validates multiple_of condition for input attribute.
        #
        # @param input [Object] Input attribute object
        # @param value [Object] Value to validate
        # @param option [WorkOption] Multiple of configuration
        # @return [Boolean] true if valid
        def condition_for_input_with(...)
          common_condition_with(...)
        end

        # Validates multiple_of condition for internal attribute.
        #
        # @param internal [Object] Internal attribute object
        # @param value [Object] Value to validate
        # @param option [WorkOption] Multiple of configuration
        # @return [Boolean] true if valid
        def condition_for_internal_with(...)
          common_condition_with(...)
        end

        # Validates multiple_of condition for output attribute.
        #
        # @param output [Object] Output attribute object
        # @param value [Object] Value to validate
        # @param option [WorkOption] Multiple of configuration
        # @return [Boolean] true if valid
        def condition_for_output_with(...)
          common_condition_with(...)
        end

        # Common validation logic for all attribute types.
        #
        # @param value [Object] Value to validate
        # @param option [WorkOption] Multiple of configuration
        # @return [Boolean] true if value is multiple of divisor
        def common_condition_with(value:, option:, **) # rubocop:disable Naming/PredicateMethod
          case value
          when Integer, Float, Rational, BigDecimal
            # Validate divisor is present and valid.
            return false if option.value.blank?
            return false unless option.value.is_a?(Numeric)
            return false if option.value.zero?

            # Calculate remainder with epsilon tolerance for floats.
            remainder = value % option.value
            remainder.zero? || remainder.abs < Float::EPSILON * [value.abs, option.value.abs].max
          else
            false
          end
        end

        ########################################################################

        # Generates error message for input validation failure.
        #
        # Selects appropriate message based on divisor state:
        # - blank: divisor is nil or empty
        # - divided_by_0: divisor is zero
        # - default: standard not-multiple-of message
        #
        # @param service [Object] Service context
        # @param input [Object] Input attribute
        # @param value [Object] Failed value
        # @param option_name [Symbol] Option name
        # @param option_value [Object] Divisor value
        # @return [String] Localized error message
        def message_for_input_with(service:, input:, value:, option_name:, option_value:, **) # rubocop:disable Metrics/MethodLength
          i18n_key = "inputs.validations.must.dynamic_options.multiple_of"

          i18n_key += if option_value.blank?
                        ".blank"
                      elsif option_value.is_a?(Numeric) && option_value.zero?
                        ".divided_by_0"
                      else
                        ".default"
                      end

          service.translate(
            i18n_key,
            input_name: input.name,
            value:,
            option_name:,
            option_value: option_value.inspect
          )
        end

        # Generates error message for internal validation failure.
        #
        # @param service [Object] Service context
        # @param internal [Object] Internal attribute
        # @param value [Object] Failed value
        # @param option_name [Symbol] Option name
        # @param option_value [Object] Divisor value
        # @return [String] Localized error message
        def message_for_internal_with(service:, internal:, value:, option_name:, option_value:, **) # rubocop:disable Metrics/MethodLength
          i18n_key = "internals.validations.must.dynamic_options.multiple_of"

          i18n_key += if option_value.blank?
                        ".blank"
                      elsif option_value.is_a?(Numeric) && option_value.zero?
                        ".divided_by_0"
                      else
                        ".default"
                      end

          service.translate(
            i18n_key,
            internal_name: internal.name,
            value:,
            option_name:,
            option_value: option_value.inspect
          )
        end

        # Generates error message for output validation failure.
        #
        # @param service [Object] Service context
        # @param output [Object] Output attribute
        # @param value [Object] Failed value
        # @param option_name [Symbol] Option name
        # @param option_value [Object] Divisor value
        # @return [String] Localized error message
        def message_for_output_with(service:, output:, value:, option_name:, option_value:, **) # rubocop:disable Metrics/MethodLength
          i18n_key = "outputs.validations.must.dynamic_options.multiple_of"

          i18n_key += if option_value.blank?
                        ".blank"
                      elsif option_value.is_a?(Numeric) && option_value.zero?
                        ".divided_by_0"
                      else
                        ".default"
                      end

          service.translate(
            i18n_key,
            output_name: output.name,
            value:,
            option_name:,
            option_value: option_value.inspect
          )
        end
      end
    end
  end
end
