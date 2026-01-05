# frozen_string_literal: true

module Servactory
  module ToolKit
    module DynamicOptions
      # Base class for creating custom dynamic validation options.
      #
      # ## Purpose
      #
      # Must provides a foundation for implementing custom validation rules
      # that can be applied to service inputs, internals, and outputs.
      # It handles the complexity of option parsing, condition evaluation,
      # and error message generation, allowing subclasses to focus on
      # validation logic.
      #
      # ## Usage
      #
      # Create a custom validator by inheriting from Must:
      #
      # ```ruby
      # class MyValidator < Servactory::ToolKit::DynamicOptions::Must
      #   def self.use(option_name = :my_option)
      #     new(option_name).must(:my_validation)
      #   end
      #
      #   def condition_for_input_with(input:, value:, option:)
      #     # Return true if valid, false otherwise
      #     value.meets_criteria?(option.value)
      #   end
      #
      #   def message_for_input_with(input:, value:, option_name:, option_value:, **)
      #     "Input `#{input.name}` must satisfy #{option_name}"
      #   end
      #
      #   # Implement similar methods for internal and output...
      # end
      # ```
      #
      # Register in service configuration:
      #
      # ```ruby
      # configuration do
      #   input_option_helpers([
      #     MyValidator.use
      #   ])
      # end
      # ```
      #
      # ## Simple Mode
      #
      # Custom validators support simple mode with direct value:
      #
      # ```ruby
      # input :value, type: Integer, my_option: 10
      # ```
      #
      # ## Advanced Mode
      #
      # Custom validators support advanced mode with custom messages:
      #
      # With static message:
      #
      # ```ruby
      # input :value, type: Integer, my_option: {
      #   is: 10,
      #   message: "Custom validation failed"
      # }
      # ```
      #
      # With dynamic lambda message:
      #
      # ```ruby
      # input :value, type: Integer, my_option: {
      #   is: 10,
      #   message: lambda do |input:, value:, option_value:, **|
      #     "Input `#{input.name}` failed validation with value `#{value}`"
      #   end
      # }
      # ```
      #
      # Lambda receives the following parameters:
      # - For inputs: `input:, option_value:, value:, **`
      # - For internals: `internal:, option_value:, value:, **`
      # - For outputs: `output:, option_value:, value:, **`
      #
      # ## Architecture
      #
      # The class uses a two-phase validation approach:
      # 1. **Condition phase**: `condition_for_*` methods return boolean
      # 2. **Message phase**: `message_for_*` methods generate error text
      #
      # ## Important Notes
      #
      # - Subclasses must implement all six abstract methods
      # - Option values support both simple mode (`option: value`) and
      #   advanced mode (`option: { is: value, message: "..." }`)
      # - Custom messages can be strings or Procs for dynamic generation
      class Must # rubocop:disable Metrics/ClassLength
        # Value object representing a parsed validation option.
        #
        # ## Purpose
        #
        # WorkOption normalizes the various ways an option can be specified
        # (simple value, hash with `:is` key, hash with custom message)
        # into a consistent interface for validators.
        #
        # ## Attributes
        #
        # - `name` - The option name symbol (e.g., `:min`, `:max`)
        # - `value` - The actual validation value (e.g., `10` for `min: 10`)
        # - `message` - Custom error message (String or Proc), or nil
        # - `properties` - Additional hash properties passed with the option
        class WorkOption
          attr_reader :name,
                      :value,
                      :message,
                      :properties

          # Creates a new WorkOption by parsing option data.
          #
          # @param name [Symbol] The option name
          # @param data [Object] Raw option value (can be scalar, Hash, etc.)
          # @param body_key [Symbol] Key to extract value from Hash (default: :is)
          # @param body_fallback [Object] Default value if data is empty
          def initialize(name, data, body_key:, body_fallback:)
            @name = name

            # Extract the primary value from data.
            @value =
              if data.is_a?(Hash) && data.key?(body_key)
                data.delete(body_key)
              else
                data.presence || body_fallback
              end

            # Extract custom message if provided.
            @message = (data.is_a?(Hash) && data.key?(:message) ? data.delete(:message) : nil)

            # Remaining hash properties become additional configuration.
            @properties = data.is_a?(Hash) ? data : {}
          end
        end

        # Creates a new Must instance.
        #
        # @param option_name [Symbol] Name of the option (e.g., :min, :max)
        # @param body_key [Symbol] Key for extracting value in advanced mode
        # @param body_fallback [Object] Default value when none provided
        def initialize(option_name, body_key = :is, body_fallback = nil)
          @option_name = option_name
          @body_key = body_key
          @body_fallback = body_fallback
        end

        # Creates an OptionHelper for registration with Servactory.
        #
        # @param name [Symbol] Internal validation name
        # @return [Servactory::Maintenance::Attributes::OptionHelper]
        def must(name)
          Servactory::Maintenance::Attributes::OptionHelper.new(
            name: @option_name,
            equivalent: equivalent_with(name),
            meta: {
              type: :dynamic_option,
              body_key: @body_key
            }
          )
        end

        # Builds the equivalence lambda for option transformation.
        #
        # @param name [Symbol] Validation name
        # @return [Proc] Lambda that transforms option data to must format
        def equivalent_with(name)
          lambda do |data|
            option = WorkOption.new(@option_name, data, body_key: @body_key, body_fallback: @body_fallback)

            {
              must: {
                name => must_content_with(option)
              }
            }
          end
        end

        # Constructs the must content hash with value and message lambdas.
        #
        # @param option [WorkOption] Parsed option data
        # @return [Hash] Hash with :is and :message keys
        def must_content_with(option)
          {
            is: must_content_value_with(option),
            message: must_content_message_with(option)
          }
        end

        ########################################################################

        # Builds the validation condition lambda.
        #
        # @param option [WorkOption] Parsed option data
        # @return [Proc] Lambda that evaluates validation condition
        def must_content_value_with(option)
          lambda do |value:, input: nil, internal: nil, output: nil|
            if input.present? && input.input?
              condition_for_input_with(input:, value:, option:)
            elsif internal.present? && internal.internal?
              condition_for_internal_with(internal:, value:, option:)
            elsif output.present? && output.output?
              condition_for_output_with(output:, value:, option:)
            end
          end
        end

        # Builds the error message lambda.
        #
        # Handles three message sources:
        # 1. Custom Proc message (called with context)
        # 2. Custom String message (returned as-is)
        # 3. Default message from subclass implementation
        #
        # @param option [WorkOption] Parsed option data
        # @return [Proc] Lambda that generates error message
        # rubocop:disable Metrics/MethodLength, Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
        def must_content_message_with(option)
          is_option_message_present = option.message.present?
          is_option_message_proc = option.message.is_a?(Proc) if is_option_message_present

          lambda do |input: nil, internal: nil, output: nil, **attributes| # rubocop:disable Metrics/BlockLength
            default_attributes = { **attributes, option_name: option.name, option_value: option.value }

            if Servactory::Utils.really_input?(input)
              if is_option_message_present
                if is_option_message_proc
                  option.message.call(
                    input:,
                    **default_attributes.delete(:meta) || {},
                    **default_attributes
                  )
                else
                  option.message
                end
              else
                message_for_input_with(**default_attributes, input:)
              end
            elsif Servactory::Utils.really_internal?(internal)
              if is_option_message_present
                if is_option_message_proc
                  option.message.call(
                    internal:,
                    **default_attributes.delete(:meta) || {},
                    **default_attributes
                  )
                else
                  option.message
                end
              else
                message_for_internal_with(**default_attributes, internal:)
              end
            elsif Servactory::Utils.really_output?(output)
              if is_option_message_present
                if is_option_message_proc
                  option.message.call(
                    output:,
                    **default_attributes.delete(:meta) || {},
                    **default_attributes
                  )
                else
                  option.message
                end
              else
                message_for_output_with(**default_attributes, output:)
              end
            end
          end
        end
        # rubocop:enable Metrics/MethodLength, Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

        ########################################################################

        # Validates condition for input attribute.
        #
        # @abstract Subclasses must implement this method
        # @param input [Object] Input attribute object
        # @param value [Object] Current value being validated
        # @param option [WorkOption] Validation option configuration
        # @return [Boolean] true if valid, false otherwise
        # @raise [RuntimeError] If not implemented in subclass
        def condition_for_input_with(**)
          raise "Need to implement `condition_for_input_with(**attributes)` method"
        end

        # Validates condition for internal attribute.
        #
        # @abstract Subclasses must implement this method
        # @param internal [Object] Internal attribute object
        # @param value [Object] Current value being validated
        # @param option [WorkOption] Validation option configuration
        # @return [Boolean] true if valid, false otherwise
        # @raise [RuntimeError] If not implemented in subclass
        def condition_for_internal_with(**)
          raise "Need to implement `condition_for_internal_with(**attributes)` method"
        end

        # Validates condition for output attribute.
        #
        # @abstract Subclasses must implement this method
        # @param output [Object] Output attribute object
        # @param value [Object] Current value being validated
        # @param option [WorkOption] Validation option configuration
        # @return [Boolean] true if valid, false otherwise
        # @raise [RuntimeError] If not implemented in subclass
        def condition_for_output_with(**)
          raise "Need to implement `condition_for_output_with(**attributes)` method"
        end

        # Generates error message for input validation failure.
        #
        # @abstract Subclasses must implement this method
        # @param input [Object] Input attribute object
        # @param option_name [Symbol] Name of the failed option
        # @param option_value [Object] Expected value
        # @return [String] Human-readable error message
        # @raise [RuntimeError] If not implemented in subclass
        def message_for_input_with(**)
          raise "Need to implement `message_for_input_with(**attributes)` method"
        end

        # Generates error message for internal validation failure.
        #
        # @abstract Subclasses must implement this method
        # @param internal [Object] Internal attribute object
        # @param option_name [Symbol] Name of the failed option
        # @param option_value [Object] Expected value
        # @return [String] Human-readable error message
        # @raise [RuntimeError] If not implemented in subclass
        def message_for_internal_with(**)
          raise "Need to implement `message_for_internal_with(**attributes)` method"
        end

        # Generates error message for output validation failure.
        #
        # @abstract Subclasses must implement this method
        # @param output [Object] Output attribute object
        # @param option_name [Symbol] Name of the failed option
        # @param option_value [Object] Expected value
        # @return [String] Human-readable error message
        # @raise [RuntimeError] If not implemented in subclass
        def message_for_output_with(**)
          raise "Need to implement `message_for_output_with(**attributes)` method"
        end
      end
    end
  end
end
