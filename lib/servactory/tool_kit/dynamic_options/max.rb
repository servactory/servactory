# frozen_string_literal: true

module Servactory
  module ToolKit
    module DynamicOptions
      # Validates that attribute value does not exceed a maximum limit.
      #
      # ## Purpose
      #
      # Max provides upper bound validation for numeric values and
      # size-based validation for collections and strings. It ensures
      # that values stay within acceptable limits.
      #
      # ## Usage
      #
      # This option is **NOT included by default**. Register it for each
      # attribute type where you want to use it:
      #
      # ```ruby
      # configuration do
      #   input_option_helpers([
      #     Servactory::ToolKit::DynamicOptions::Max.use
      #   ])
      #
      #   internal_option_helpers([
      #     Servactory::ToolKit::DynamicOptions::Max.use
      #   ])
      #
      #   output_option_helpers([
      #     Servactory::ToolKit::DynamicOptions::Max.use
      #   ])
      # end
      # ```
      #
      # Use in your service definition:
      #
      # ```ruby
      # class ProcessDataService < ApplicationService::Base
      #   input :count, type: Integer, max: 100
      #   input :name, type: String, max: 255
      #   input :items, type: Array, max: 50
      # end
      # ```
      #
      # ## Simple Mode
      #
      # Specify maximum value directly:
      #
      # ```ruby
      # class ProcessDataService < ApplicationService::Base
      #   input :count, type: Integer, max: 100
      #   input :name, type: String, max: 255
      #   input :items, type: Array, max: 50
      # end
      # ```
      #
      # ## Advanced Mode
      #
      # Specify maximum with custom error message using a hash:
      #
      # With static message:
      #
      # ```ruby
      # input :count, type: Integer, max: {
      #   is: 100,
      #   message: "Input `count` must not exceed 100"
      # }
      # ```
      #
      # With dynamic lambda message:
      #
      # ```ruby
      # input :count, type: Integer, max: {
      #   is: 100,
      #   message: lambda do |input:, value:, option_value:, **|
      #     "Input `#{input.name}` must be <= #{option_value}, got #{value}"
      #   end
      # }
      # ```
      #
      # Lambda receives the following parameters:
      # - For inputs: `input:, option_value:, value:, **`
      # - For internals: `internal:, option_value:, value:, **`
      # - For outputs: `output:, option_value:, value:, **`
      #
      # ## Validation Rules
      #
      # - For Integer: value must be <= max
      # - For String/Array/Hash: size must be <= max
      # - Objects must respond to `:size` method for size-based validation
      #
      # ## Important Notes
      #
      # - Returns false if value doesn't support size comparison
      # - Combines well with `:min` for range validation
      class Max < Must
        # Creates a Max validator instance.
        #
        # @param option_name [Symbol] The option name (default: :max)
        # @return [Servactory::Maintenance::Attributes::OptionHelper]
        def self.use(option_name = :max)
          new(option_name).must(:be_less_than_or_equal_to)
        end

        # Validates max condition for input attribute.
        #
        # @param input [Object] Input attribute object
        # @param value [Object] Value to validate
        # @param option [WorkOption] Max configuration
        # @return [Boolean] true if valid
        def condition_for_input_with(...)
          common_condition_with(...)
        end

        # Validates max condition for internal attribute.
        #
        # @param internal [Object] Internal attribute object
        # @param value [Object] Value to validate
        # @param option [WorkOption] Max configuration
        # @return [Boolean] true if valid
        def condition_for_internal_with(...)
          common_condition_with(...)
        end

        # Validates max condition for output attribute.
        #
        # @param output [Object] Output attribute object
        # @param value [Object] Value to validate
        # @param option [WorkOption] Max configuration
        # @return [Boolean] true if valid
        def condition_for_output_with(...)
          common_condition_with(...)
        end

        # Common validation logic for all attribute types.
        #
        # @param value [Object] Value to validate
        # @param option [WorkOption] Max configuration
        # @return [Boolean] true if value <= max
        def common_condition_with(value:, option:, **) # rubocop:disable Naming/PredicateMethod
          case value
          when Integer
            # Direct numeric comparison.
            value <= option.value
          else
            # Size-based comparison for collections and strings.
            return false unless value.respond_to?(:size)

            value.size <= option.value
          end
        end

        ########################################################################

        # Generates error message for input validation failure.
        #
        # @param service [Object] Service context
        # @param input [Object] Input attribute
        # @param value [Object] Failed value
        # @param option_name [Symbol] Option name
        # @param option_value [Object] Maximum limit
        # @return [String] Localized error message
        def message_for_input_with(service:, input:, value:, option_name:, option_value:, **)
          service.translate(
            "inputs.validations.must.dynamic_options.max.default",
            input_name: input.name,
            value:,
            option_name:,
            option_value:
          )
        end

        # Generates error message for internal validation failure.
        #
        # @param service [Object] Service context
        # @param internal [Object] Internal attribute
        # @param value [Object] Failed value
        # @param option_name [Symbol] Option name
        # @param option_value [Object] Maximum limit
        # @return [String] Localized error message
        def message_for_internal_with(service:, internal:, value:, option_name:, option_value:, **)
          service.translate(
            "internals.validations.must.dynamic_options.max.default",
            internal_name: internal.name,
            value:,
            option_name:,
            option_value:
          )
        end

        # Generates error message for output validation failure.
        #
        # @param service [Object] Service context
        # @param output [Object] Output attribute
        # @param value [Object] Failed value
        # @param option_name [Symbol] Option name
        # @param option_value [Object] Maximum limit
        # @return [String] Localized error message
        def message_for_output_with(service:, output:, value:, option_name:, option_value:, **)
          service.translate(
            "outputs.validations.must.dynamic_options.max.default",
            output_name: output.name,
            value:,
            option_name:,
            option_value:
          )
        end
      end
    end
  end
end
