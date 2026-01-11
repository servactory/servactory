# frozen_string_literal: true

module Servactory
  module Inputs
    module Validations
      class Required
        extend Servactory::Maintenance::Attributes::Validations::Concerns::ErrorBuilder

        # Validates that required input has a value without instance allocation.
        #
        # Optimized for the common case (validation success) with zero allocations.
        # Returns error message string on failure, nil on success.
        #
        # @param context [Object] Service context
        # @param attribute [Inputs::Input] Input attribute to validate
        # @param value [Object] Value to validate
        # @param check_key [Symbol] Validation check key
        # @return [String, nil] nil on success, error message on failure
        def self.check(context:, attribute:, value:, check_key:, **)
          return unless should_be_checked_for?(attribute, check_key)
          return if Servactory::Utils.value_present?(value)

          build_error_message(context:, input: attribute, value:)
        end

        def self.should_be_checked_for?(input, check_key)
          check_key == :required && input.required?
        end

        # Builds error message from validation failure.
        #
        # @param context [Object] Service context
        # @param input [Inputs::Input] Input that failed validation
        # @param value [Object] The invalid value
        # @return [String] Processed error message
        def self.build_error_message(context:, input:, value:)
          _, message = input.required.values_at(:is, :message)
          message = message.presence || Servactory::Inputs::Translator::Required.default_message

          process_message(
            message,
            service: context.send(:servactory_service_info),
            input:,
            value:
          )
        end
        private_class_method :build_error_message
      end
    end
  end
end
