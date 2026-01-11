# frozen_string_literal: true

module Servactory
  module Inputs
    module Validations
      # Validates that required inputs have non-empty values.
      #
      # ## Purpose
      #
      # Required validator ensures that inputs marked as `required: true`
      # have meaningful values. It checks for presence using `value_present?`
      # which handles nil, empty strings, and blank values.
      #
      # ## Usage
      #
      # This validator is automatically applied to inputs with `required: true`:
      #
      # ```ruby
      # class MyService < ApplicationService::Base
      #   input :email, type: String, required: true
      #   input :name, type: String, required: { message: "Name is mandatory" }
      # end
      # ```
      #
      # ## Architecture
      #
      # - Checks value presence using Utils.value_present?
      # - Delegates message processing to ErrorBuilder concern
      # - Returns nil on success, error message String on failure
      class Required
        extend Servactory::Maintenance::Attributes::Validations::Concerns::ErrorBuilder

        # Validates that a required input has a present value.
        #
        # @param context [Object] Service context for error message formatting
        # @param attribute [Inputs::Input] Input attribute to validate
        # @param value [Object] Value to check for presence
        # @param check_key [Symbol] Must be :required to trigger validation
        # @return [String, nil] Error message on failure, nil on success
        def self.check(context:, attribute:, value:, check_key:, **)
          return unless should_be_checked_for?(attribute, check_key)
          return if Servactory::Utils.value_present?(value)

          build_error_message(context:, input: attribute, value:)
        end

        # Determines if validation should run for given input and check key.
        #
        # @param input [Inputs::Input] Input to check
        # @param check_key [Symbol] Current validation check key
        # @return [Boolean] true if this validator should run
        def self.should_be_checked_for?(input, check_key)
          check_key == :required && input.required?
        end
        private_class_method :should_be_checked_for?

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
