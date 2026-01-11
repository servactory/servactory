# frozen_string_literal: true

module Servactory
  module Maintenance
    module Attributes
      module Validations
        class Must
          extend Concerns::ErrorBuilder

          # Validates must conditions without instance allocation on success.
          #
          # Optimized for the common case (validation success) with zero allocations.
          # Only allocates Errors object when validation fails.
          #
          # @param context [Object] Service context
          # @param attribute [Inputs::Input, Internals::Internal, Outputs::Output] Attribute to validate
          # @param value [Object] Value to validate
          # @param check_key [Symbol] Validation check key
          # @param check_options [Hash] Must check options with conditions
          # @return [Errors, nil] nil on success, Errors on failure
          def self.check(context:, attribute:, value:, check_key:, check_options:)
            return unless should_be_checked_for?(attribute, check_key)

            errors = nil

            check_options.each do |code, options|
              error_message = validate_condition(context:, attribute:, value:, code:, options:)
              next if error_message.nil?

              errors ||= Errors.new
              errors << error_message
            end

            errors
          end

          def self.should_be_checked_for?(attribute, check_key)
            check_key == :must && attribute.must_present?
          end

          # Validates a single must condition.
          #
          # @param context [Object] Service context
          # @param attribute [Inputs::Input, Internals::Internal, Outputs::Output] Attribute
          # @param value [Object] Value being validated
          # @param code [Symbol] Must condition code
          # @param options [Hash] Options for this condition (:is, :message)
          # @return [String, nil] Error message or nil on success
          def self.validate_condition(context:, attribute:, value:, code:, options:) # rubocop:disable Metrics/MethodLength
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

          # Calls the check lambda with error handling for syntax errors.
          #
          # @return [Array] [check_result, check_result_code, meta] or [:syntax_error, error_message, nil]
          def self.call_check(context:, attribute:, value:, check:, code:) # rubocop:disable Metrics/MethodLength
            check.call(value:, **Servactory::Utils.fetch_hash_with_desired_attribute(attribute))
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
          # NOTE: message.call errors are NOT caught - they propagate to caller.
          #
          # @return [String] Processed error message
          def self.build_error_message(context:, attribute:, value:, code:, reason:, meta:, message:)
            message = message.presence || Servactory::Maintenance::Attributes::Translator::Must.default_message

            process_message(
              message,
              service: context.send(:servactory_service_info),
              **Servactory::Utils.fetch_hash_with_desired_attribute(attribute),
              value:,
              code:,
              reason:,
              meta:
            )
          end
          private_class_method :build_error_message

          # Builds syntax error message.
          #
          # @return [String] Processed syntax error message
          def self.build_syntax_error_message(context:, attribute:, value:, code:, exception_message:)
            message = Servactory::Maintenance::Attributes::Translator::Must.syntax_error_message

            process_message(
              message,
              service: context.send(:servactory_service_info),
              **Servactory::Utils.fetch_hash_with_desired_attribute(attribute),
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
