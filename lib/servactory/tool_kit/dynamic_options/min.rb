# frozen_string_literal: true

module Servactory
  module ToolKit
    module DynamicOptions
      # Validates that attribute value meets a minimum threshold.
      #
      # ## Purpose
      #
      # Min provides lower bound validation for numeric values and
      # size-based validation for collections and strings. It ensures
      # that values meet minimum requirements.
      #
      # ## Usage
      #
      # This option is **NOT included by default**. Register it for each
      # attribute type where you want to use it:
      #
      # ```ruby
      # configuration do
      #   input_option_helpers([
      #     Servactory::ToolKit::DynamicOptions::Min.use
      #   ])
      #
      #   internal_option_helpers([
      #     Servactory::ToolKit::DynamicOptions::Min.use
      #   ])
      #
      #   output_option_helpers([
      #     Servactory::ToolKit::DynamicOptions::Min.use
      #   ])
      # end
      # ```
      #
      # Use in your service definition:
      #
      # ```ruby
      # class Data::Process < ApplicationService::Base
      #   input :age, type: Integer, min: 18
      #   input :password, type: String, min: 8
      #   input :tags, type: Array, min: 1
      # end
      # ```
      #
      # ## Simple Mode
      #
      # Specify minimum value directly:
      #
      # ```ruby
      # class Data::Process < ApplicationService::Base
      #   input :age, type: Integer, min: 18
      #   input :password, type: String, min: 8
      #   input :tags, type: Array, min: 1
      # end
      # ```
      #
      # ## Advanced Mode
      #
      # Specify minimum with custom error message using a hash:
      #
      # With static message:
      #
      # ```ruby
      # input :age, type: Integer, min: {
      #   is: 18,
      #   message: "Input `age` must be at least 18"
      # }
      # ```
      #
      # With dynamic lambda message:
      #
      # ```ruby
      # input :age, type: Integer, min: {
      #   is: 18,
      #   message: lambda do |input:, value:, option_value:, **|
      #     "Input `#{input.name}` must be >= #{option_value}, got #{value}"
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
      # - For Integer: value must be >= min
      # - For String/Array/Hash: size must be >= min
      # - Objects must respond to `:size` method for size-based validation
      #
      # ## Important Notes
      #
      # - Returns false if value doesn't support size comparison
      # - Combines well with `:max` for range validation
      class Min < Must
        # Creates a Min validator instance.
        #
        # @param option_name [Symbol] The option name (default: :min)
        # @return [Servactory::Maintenance::Attributes::OptionHelper]
        def self.use(option_name = :min)
          new(option_name).must(:be_greater_than_or_equal_to)
        end

        # Validates min condition for input attribute.
        #
        # @param input [Object] Input attribute object
        # @param value [Object] Value to validate
        # @param option [WorkOption] Min configuration
        # @return [Boolean] true if valid
        def condition_for_input_with(...)
          common_condition_with(...)
        end

        # Validates min condition for internal attribute.
        #
        # @param internal [Object] Internal attribute object
        # @param value [Object] Value to validate
        # @param option [WorkOption] Min configuration
        # @return [Boolean] true if valid
        def condition_for_internal_with(...)
          common_condition_with(...)
        end

        # Validates min condition for output attribute.
        #
        # @param output [Object] Output attribute object
        # @param value [Object] Value to validate
        # @param option [WorkOption] Min configuration
        # @return [Boolean] true if valid
        def condition_for_output_with(...)
          common_condition_with(...)
        end

        # Common validation logic for all attribute types.
        #
        # @param value [Object] Value to validate
        # @param option [WorkOption] Min configuration
        # @return [Boolean] true if value >= min
        def common_condition_with(value:, option:, **) # rubocop:disable Naming/PredicateMethod
          case value
          when Integer
            # Direct numeric comparison.
            value >= option.value
          else
            # Size-based comparison for collections and strings.
            return false unless value.respond_to?(:size)

            value.size >= option.value
          end
        end

        ########################################################################

        # Generates error message for input validation failure.
        #
        # @param service [Object] Service context
        # @param input [Object] Input attribute
        # @param value [Object] Failed value
        # @param option_name [Symbol] Option name
        # @param option_value [Object] Minimum limit
        # @return [String] Localized error message
        def message_for_input_with(service:, input:, value:, option_name:, option_value:, **)
          service.translate(
            "inputs.validations.must.dynamic_options.min.default",
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
        # @param option_value [Object] Minimum limit
        # @return [String] Localized error message
        def message_for_internal_with(service:, internal:, value:, option_name:, option_value:, **)
          service.translate(
            "internals.validations.must.dynamic_options.min.default",
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
        # @param option_value [Object] Minimum limit
        # @return [String] Localized error message
        def message_for_output_with(service:, output:, value:, option_name:, option_value:, **)
          service.translate(
            "outputs.validations.must.dynamic_options.min.default",
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
