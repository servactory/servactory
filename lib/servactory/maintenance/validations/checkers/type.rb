# frozen_string_literal: true

module Servactory
  module Maintenance
    module Validations
      module Checkers
        # Validates that attribute values match their declared types.
        #
        # ## Purpose
        #
        # Type validator ensures attribute values conform to declared type
        # constraints. It supports single types, union types (arrays), and
        # custom type definitions. Works with inputs, internals, and outputs.
        #
        # ## Usage
        #
        # Type validation is automatic based on the `type` option:
        #
        # ```ruby
        # class MyService < ApplicationService::Base
        #   input :id, type: Integer
        #   input :data, type: [Hash, Array]  # union type
        #   input :status, type: String, required: false
        #
        #   internal :result, type: CustomType
        #   output :response, type: Hash
        # end
        # ```
        class Type
          extend Concerns::ErrorBuilder

          # Validates that a value matches the declared attribute types.
          #
          # @param context [Object] Service context for error formatting
          # @param attribute [Inputs::Input, Internals::Internal, Outputs::Output] Attribute to validate
          # @param value [Object] Value to check against declared types
          # @param check_key [Symbol] Must be :types to trigger validation
          # @return [String, nil] Error message on type mismatch, nil on success
          def self.check(context:, attribute:, value:, check_key:, check_options: nil) # rubocop:disable Lint/UnusedMethodArgument
            return unless should_be_checked_for?(attribute, value, check_key)

            prepared_value = compute_prepared_value(attribute, value)

            error_data = Servactory::Maintenance::Validations::Support::TypeValidator.validate(
              context:,
              attribute:,
              types: attribute.types,
              value: prepared_value
            )

            return if error_data.nil?

            build_error_message(error_data)
          end

          # Determines if type validation should run for given attribute.
          #
          # Type validation runs when:
          # - check_key is :types AND one of:
          #   - Input is required
          #   - Input is optional with non-nil default
          #   - Input is optional with non-nil value
          #   - Attribute is internal or output (always validated)
          #
          # @param attribute [Inputs::Input, Internals::Internal, Outputs::Output] Attribute to check
          # @param value [Object] Current value (for optional input check)
          # @param check_key [Symbol] Current validation check key
          # @return [Boolean] true if type validation should run
          # rubocop:disable Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
          def self.should_be_checked_for?(attribute, value, check_key)
            check_key == :types && (
              (
                attribute.input? && (
                  attribute.required? || (
                    attribute.optional? && !attribute.default.nil?
                  ) || (
                    attribute.optional? && !value.nil?
                  )
                )
              ) || attribute.internal? || attribute.output?
            )
          end
          # rubocop:enable Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
          private_class_method :should_be_checked_for?

          # Computes prepared value with default substitution for optional inputs.
          #
          # @param attribute [Inputs::Input, Internals::Internal, Outputs::Output] Attribute
          # @param value [Object] Original value
          # @return [Object] Prepared value (default or original)
          def self.compute_prepared_value(attribute, value)
            if attribute.input? && attribute.optional? && !attribute.default.nil? && value.blank?
              attribute.default
            else
              value
            end
          end
          private_class_method :compute_prepared_value

          # Builds error message from validation error data.
          #
          # @param error_data [Hash] Error data from TypeValidator.validate
          # @return [String] Processed error message
          def self.build_error_message(error_data)
            process_message(error_data[:message], **error_data)
          end
          private_class_method :build_error_message
        end
      end
    end
  end
end
