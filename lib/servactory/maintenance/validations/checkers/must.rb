# frozen_string_literal: true

module Servactory
  module Maintenance
    module Validations
      module Checkers
        # Validates custom conditions defined with `must` option.
        #
        # ## Purpose
        #
        # Must validator executes user-defined validation lambdas against attribute
        # values. It supports multiple named conditions per attribute and provides
        # rich error context including custom messages, reason codes, and metadata.
        #
        # ## Usage
        #
        # Define must conditions on any attribute (input, internal, output):
        #
        # ```ruby
        # class MyService < ApplicationService::Base
        #   input :age,
        #         type: Integer,
        #         must: {
        #           be_adult: {
        #             is: ->(value:) { value >= 18 },
        #             message: "Must be 18 or older"
        #           }
        #         }
        #
        #   internal :discount,
        #            type: Float,
        #            must: {
        #              be_percentage: {
        #                is: ->(value:) { value.between?(0, 100) }
        #              }
        #            }
        # end
        # ```
        class Must
          extend Concerns::ErrorBuilder

          # Validates all must conditions for an attribute.
          #
          # Iterates through check_options and validates each condition.
          # Returns on first failure (early return pattern).
          #
          # @param context [Object] Service context for error message formatting
          # @param attribute [Inputs::Input, Internals::Internal, Outputs::Output] Attribute to validate
          # @param value [Object] Value to validate against conditions
          # @param check_key [Symbol] Must be :must to trigger validation
          # @param check_options [Hash{Symbol => Hash}] Named conditions with :is and :message
          # @return [String, nil] Error message on first failure, nil if all pass
          def self.check(context:, attribute:, value:, check_key:, check_options:)
            return unless should_be_checked_for?(attribute, check_key)

            check_options.each do |code, options|
              error_message = validate_condition(context:, attribute:, value:, code:, options:)
              return error_message if error_message.present?
            end

            nil
          end

          # Determines if validation should run for given attribute and check key.
          #
          # @param attribute [Inputs::Input, Internals::Internal, Outputs::Output] Attribute to check
          # @param check_key [Symbol] Current validation check key
          # @return [Boolean] true if this validator should run
          def self.should_be_checked_for?(attribute, check_key)
            check_key == :must && attribute.must_present?
          end
          private_class_method :should_be_checked_for?

          # Validates a single must condition by executing its check lambda.
          #
          # Executes the check lambda and handles three outcomes:
          # - Lambda returns true: validation passes (returns nil)
          # - Lambda returns [false, reason, meta]: validation fails with context
          # - Lambda raises exception: returns syntax error message
          #
          # @param context [Object] Service context for error formatting
          # @param attribute [Inputs::Input, Internals::Internal, Outputs::Output] Attribute being validated
          # @param value [Object] Value to pass to check lambda
          # @param code [Symbol] Condition identifier (e.g., :be_adult)
          # @param options [Hash, Proc] Condition options with :is (lambda) and :message, or just a lambda
          # @return [String, nil] Error message on failure, nil on success
          def self.validate_condition(context:, attribute:, value:, code:, options:) # rubocop:disable Metrics/MethodLength
            options = normalize_rule_options(options)
            check, message = options.values_at(:is, :message)

            check_result, check_result_code, meta = call_check(
              context:,
              attribute:,
              value:,
              check:,
              code:
            )

            # check_result is :syntax_error when syntax error occurred
            return check_result_code if check_result == :syntax_error
            return if check_result == true

            build_error_message(
              context:,
              attribute:,
              value:,
              code:,
              reason: check_result_code,
              meta:,
              message:
            )
          end
          private_class_method :validate_condition

          # Normalizes rule options to always have :is and :message keys.
          #
          # Supports Simple Mode where only a lambda is provided:
          #   must: { be_adult: ->(value:) { value >= 18 } }
          # Converts to Advanced Mode format:
          #   must: { be_adult: { is: lambda, message: nil } }
          #
          # @param options [Hash, Proc] Either { is: lambda, message: ... } or just lambda
          # @return [Hash] Normalized options with :is and :message keys
          def self.normalize_rule_options(options)
            return options if options.is_a?(Hash)

            { is: options, message: nil }
          end
          private_class_method :normalize_rule_options

          # Executes the check lambda with exception handling.
          #
          # Catches any StandardError from the lambda and converts it to a
          # formatted syntax error message for better debugging experience.
          #
          # @param context [Object] Service context for error formatting
          # @param attribute [Inputs::Input, Internals::Internal, Outputs::Output] Attribute being validated
          # @param value [Object] Value to pass to lambda
          # @param check [Proc] The validation lambda to execute
          # @param code [Symbol] Condition identifier for error messages
          # @return [Array] On success: [result, reason_code, meta_hash]
          # @return [Array] On exception: [:syntax_error, error_message_string, nil]
          def self.call_check(context:, attribute:, value:, check:, code:)
            check.call(value:, **attribute.desired_attribute_hash)
          rescue StandardError => e
            # Return formatted syntax error message
            syntax_error_message = build_syntax_error_message(
              context:,
              attribute:,
              value:,
              code:,
              exception_message: e.message
            )
            [:syntax_error, syntax_error_message, nil]
          end
          private_class_method :call_check

          # Builds error message from validation failure.
          #
          # Uses custom message if provided, otherwise falls back to default.
          # Message can be a String or Proc for dynamic formatting.
          #
          # NOTE: Errors from message.call are NOT caught - they propagate to caller.
          #
          # @param context [Object] Service context for message formatting
          # @param attribute [Inputs::Input, Internals::Internal, Outputs::Output] Failed attribute
          # @param value [Object] The invalid value
          # @param code [Symbol] Condition identifier
          # @param reason [Symbol, nil] Failure reason from check lambda
          # @param meta [Hash, nil] Additional metadata from check lambda
          # @param message [String, Proc, nil] Custom error message
          # @return [String] Processed error message
          def self.build_error_message(context:, attribute:, value:, code:, reason:, meta:, message:)
            message = message.presence || Servactory::Maintenance::Validations::Translator::Must.default_message

            process_message(
              message,
              service: context.send(:servactory_service_info),
              **attribute.desired_attribute_hash,
              value:,
              code:,
              reason:,
              meta:
            )
          end
          private_class_method :build_error_message

          # Builds error message for exceptions raised in check lambdas.
          #
          # Formats the exception message with context for debugging,
          # including the condition code and original exception text.
          #
          # @param context [Object] Service context for message formatting
          # @param attribute [Inputs::Input, Internals::Internal, Outputs::Output] Attribute being validated
          # @param value [Object] Value that caused the exception
          # @param code [Symbol] Condition identifier where error occurred
          # @param exception_message [String] Original exception message
          # @return [String] Formatted syntax error message
          def self.build_syntax_error_message(context:, attribute:, value:, code:, exception_message:)
            message = Servactory::Maintenance::Validations::Translator::Must.syntax_error_message

            process_message(
              message,
              service: context.send(:servactory_service_info),
              **attribute.desired_attribute_hash,
              value:,
              code:,
              exception_message:
            )
          end
          private_class_method :build_syntax_error_message
        end
      end
    end
  end
end
