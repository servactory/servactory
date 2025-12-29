# frozen_string_literal: true

module Servactory
  module ToolKit
    module DynamicOptions
      # Validates string values against predefined or custom format patterns.
      #
      # ## Purpose
      #
      # Format provides pattern-based validation for string attributes using
      # regular expressions and custom validators. It includes built-in formats
      # for common use cases (UUID, email, date, etc.) and supports custom
      # format definitions.
      #
      # ## Usage
      #
      # This option is **NOT included by default**. Register it for each
      # attribute type where you want to use it:
      #
      # ```ruby
      # configuration do
      #   input_option_helpers([
      #     Servactory::ToolKit::DynamicOptions::Format.use
      #   ])
      #
      #   internal_option_helpers([
      #     Servactory::ToolKit::DynamicOptions::Format.use
      #   ])
      #
      #   output_option_helpers([
      #     Servactory::ToolKit::DynamicOptions::Format.use
      #   ])
      # end
      # ```
      #
      # Use built-in formats in your service:
      #
      # ```ruby
      # class MyService < ApplicationService::Base
      #   input :user_id, type: String, format: :uuid
      #   input :email, type: String, format: :email
      #   input :birth_date, type: String, format: :date
      # end
      # ```
      #
      # Add custom formats:
      #
      # ```ruby
      # Format.use(formats: {
      #   phone: {
      #     pattern: /\A\+?[1-9]\d{6,14}\z/,
      #     validator: ->(value:) { value.present? }
      #   }
      # })
      # ```
      #
      # ## Supported Formats
      #
      # | Format | Description |
      # |--------|-------------|
      # | `:uuid` | Standard UUID format (8-4-4-4-12 hex digits) |
      # | `:email` | Email address per RFC 2822 |
      # | `:password` | 8-16 chars with digit, lowercase, uppercase |
      # | `:duration` | ISO 8601 duration (e.g., "PT1H30M") |
      # | `:date` | Parseable date string |
      # | `:datetime` | Parseable datetime string |
      # | `:time` | Parseable time string |
      # | `:boolean` | Truthy boolean string ("true" or "1") |
      #
      # ## Simple Mode
      #
      # Specify format directly as the option value:
      #
      # ```ruby
      # class ValidateUserService < ApplicationService::Base
      #   input :uuid, type: String, format: :uuid
      #   input :email, type: String, format: :email
      #   input :password, type: String, format: :password
      # end
      # ```
      #
      # ## Advanced Mode
      #
      # Specify format with custom error message using a hash:
      #
      # With static message:
      #
      # ```ruby
      # input :email, type: String, format: {
      #   is: :email,
      #   message: "Input `email` must be a valid email address"
      # }
      # ```
      #
      # With dynamic lambda message:
      #
      # ```ruby
      # input :email, type: String, format: {
      #   is: :email,
      #   message: lambda do |input:, value:, option_value:, **|
      #     "Input `#{input.name}` with value `#{value}` does not match `#{option_value}` format"
      #   end
      # }
      # ```
      #
      # Lambda receives the following parameters:
      # - For inputs: `input:, value:, option_value:, reason:, **`
      # - For internals: `internal:, value:, option_value:, reason:, **`
      # - For outputs: `output:, value:, option_value:, reason:, **`
      #
      # ## Important Notes
      #
      # - Optional inputs with blank values skip validation
      # - Custom patterns can be strings or Regexp objects
      # - Validators receive `value:` keyword argument
      # - Unknown format names return `:unknown` error
      # - Format validation is two-phase: pattern check (if defined), then validator callback
      # - The `:boolean` format pattern matches "true", "false", "0", "1", but validator
      #   only passes for truthy values ("true", "1"); "false" and "0" will fail validation
      class Format < Must # rubocop:disable Metrics/ClassLength
        # Built-in format definitions with patterns and validators.
        DEFAULT_FORMATS = {
          uuid: {
            pattern: /\A[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}\z/,
            validator: ->(value:) { value.present? }
          },
          email: {
            pattern: URI::MailTo::EMAIL_REGEXP,
            validator: ->(value:) { value.present? }
          },
          password: {
            # Password must contain one digit from 1 to 9, one lowercase letter, one
            # uppercase letter, and it must be 8-16 characters long.
            # Usage of any other special character and space is optional.
            # Reference: https://dev.to/rasaf_ibrahim/write-regex-password-validation-like-a-pro-5175
            pattern: /\A(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z]).{8,16}\z/,
            validator: ->(value:) { value.present? }
          },
          duration: {
            pattern: nil,
            validator: lambda do |value:|
              ActiveSupport::Duration.parse(value) and return true
            rescue ActiveSupport::Duration::ISO8601Parser::ParsingError
              false
            end
          },
          date: {
            pattern: nil,
            validator: lambda do |value:|
              Date.parse(value) and return true
            rescue Date::Error
              false
            end
          },
          datetime: {
            pattern: nil,
            validator: lambda do |value:|
              DateTime.parse(value) and return true
            rescue Date::Error
              false
            end
          },
          time: {
            pattern: nil,
            validator: lambda do |value:|
              Time.parse(value) and return true
            rescue ArgumentError
              false
            end
          },
          boolean: {
            pattern: /\A(true|false|0|1)\z/i,
            validator: ->(value:) { %w[true 1].include?(value&.downcase) }
          }
        }.freeze
        private_constant :DEFAULT_FORMATS

        # Creates a Format validator instance.
        #
        # @param option_name [Symbol] The option name (default: :format)
        # @param formats [Hash] Custom format definitions to merge with defaults
        # @return [Servactory::Maintenance::Attributes::OptionHelper]
        def self.use(option_name = :format, formats: {})
          instance = new(option_name)
          instance.assign(formats)
          instance.must(:be_in_format)
        end

        # Assigns format definitions, merging with defaults.
        #
        # @param formats [Hash] Custom formats to add
        # @return [void]
        def assign(formats = {})
          @formats = formats.is_a?(Hash) ? DEFAULT_FORMATS.merge(formats) : DEFAULT_FORMATS
        end

        # Validates format condition for input attribute.
        #
        # @param input [Object] Input attribute object
        # @param value [Object] String value to validate
        # @param option [WorkOption] Format configuration
        # @return [Boolean, Array] true if valid, or [false, reason]
        def condition_for_input_with(...)
          common_condition_with(...)
        end

        # Validates format condition for internal attribute.
        #
        # @param internal [Object] Internal attribute object
        # @param value [Object] String value to validate
        # @param option [WorkOption] Format configuration
        # @return [Boolean, Array] true if valid, or [false, reason]
        def condition_for_internal_with(...)
          common_condition_with(...)
        end

        # Validates format condition for output attribute.
        #
        # @param output [Object] Output attribute object
        # @param value [Object] String value to validate
        # @param option [WorkOption] Format configuration
        # @return [Boolean, Array] true if valid, or [false, reason]
        def condition_for_output_with(...)
          common_condition_with(...)
        end

        # Common format validation logic.
        #
        # @param value [Object] Value to validate
        # @param option [WorkOption] Format configuration
        # @param input [Object, nil] Input attribute if applicable
        # @param internal [Object, nil] Internal attribute if applicable
        # @param output [Object, nil] Output attribute if applicable
        # @return [Boolean, Array] true if valid, or [false, reason]
        # rubocop:disable Metrics/MethodLength, Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
        def common_condition_with(value:, option:, input: nil, internal: nil, output: nil)
          option_value = option.value&.to_sym

          # Check if format exists.
          return [false, :unknown] unless @formats.key?(option_value)

          attribute = Utils.define_attribute_with(input:, internal:, output:)

          # Skip validation for blank optional values.
          if value.blank? &&
             (
               (attribute.input? && attribute.optional?) ||
                 (
                   (attribute.internal? || attribute.output?) &&
                     attribute.types.include?(NilClass)
                 )
             )
            return true
          end

          format_options = @formats.fetch(option_value)

          # Get pattern from option properties or format definition.
          format_pattern = option.properties.fetch(:pattern, format_options.fetch(:pattern))

          # Validate against pattern if defined.
          if format_pattern.present?
            return [false, :wrong_type] unless value.respond_to?(:match?)

            compiled_pattern = format_pattern.is_a?(Regexp) ? format_pattern : Regexp.compile(format_pattern)
            return [false, :wrong_pattern] unless value.match?(compiled_pattern)
          end

          # Run validator callback.
          option.properties.fetch(:validator, format_options.fetch(:validator)).call(value:)
        end
        # rubocop:enable Metrics/MethodLength, Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

        ########################################################################

        # Generates error message for input validation failure.
        #
        # @param service [Object] Service context
        # @param input [Object] Input attribute
        # @param value [Object] Failed value
        # @param option_name [Symbol] Option name
        # @param option_value [Symbol] Format name
        # @param reason [Symbol] Failure reason
        # @return [String] Localized error message
        def message_for_input_with(service:, input:, value:, option_name:, option_value:, reason:, **)
          i18n_key = "inputs.validations.must.dynamic_options.format"
          i18n_key += reason.present? ? ".#{reason}" : ".default"

          service.translate(
            i18n_key,
            input_name: input.name,
            value:,
            option_name:,
            format_name: option_value.presence || option_value.inspect
          )
        end

        # Generates error message for internal validation failure.
        #
        # @param service [Object] Service context
        # @param internal [Object] Internal attribute
        # @param value [Object] Failed value
        # @param option_name [Symbol] Option name
        # @param option_value [Symbol] Format name
        # @param reason [Symbol] Failure reason
        # @return [String] Localized error message
        def message_for_internal_with(service:, internal:, value:, option_name:, option_value:, reason:, **)
          i18n_key = "internals.validations.must.dynamic_options.format"
          i18n_key += reason.present? ? ".#{reason}" : ".default"

          service.translate(
            i18n_key,
            internal_name: internal.name,
            value:,
            option_name:,
            format_name: option_value.presence || option_value.inspect
          )
        end

        # Generates error message for output validation failure.
        #
        # @param service [Object] Service context
        # @param output [Object] Output attribute
        # @param value [Object] Failed value
        # @param option_name [Symbol] Option name
        # @param option_value [Symbol] Format name
        # @param reason [Symbol] Failure reason
        # @return [String] Localized error message
        def message_for_output_with(service:, output:, value:, option_name:, option_value:, reason:, **)
          i18n_key = "outputs.validations.must.dynamic_options.format"
          i18n_key += reason.present? ? ".#{reason}" : ".default"

          service.translate(
            i18n_key,
            output_name: output.name,
            value:,
            option_name:,
            format_name: option_value.presence || option_value.inspect
          )
        end
      end
    end
  end
end
