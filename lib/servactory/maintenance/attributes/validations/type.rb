# frozen_string_literal: true

module Servactory
  module Maintenance
    module Attributes
      module Validations
        class Type
          # Validates attribute type without instance allocation.
          #
          # Optimized for the common case (validation success) with zero allocations.
          # Only allocates Errors object on validation failure.
          #
          # @param context [Object] Service context
          # @param attribute [Inputs::Input, Internals::Internal, Outputs::Output] Attribute to validate
          # @param value [Object] Value to validate
          # @param check_key [Symbol] Validation check key
          # @return [Errors, nil] nil on success, Errors on failure
          def self.check(context:, attribute:, value:, check_key:, **)
            return unless should_be_checked_for?(attribute, value, check_key)

            prepared_value = compute_prepared_value(attribute, value)

            error_data = Servactory::Maintenance::Validations::Types.validate(
              context: context,
              attribute: attribute,
              types: attribute.types,
              value: prepared_value
            )

            return if error_data.nil?

            build_errors_from(error_data)
          end

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

          # Builds Errors from validation error data.
          #
          # @param error_data [Hash] Error data from Types.validate_type
          # @return [Errors] Errors collection with processed message
          def self.build_errors_from(error_data)
            errors = Errors.new
            message = error_data[:message]
            message = message.call(**error_data) if message.is_a?(Proc)
            errors << message
            errors
          end
          private_class_method :build_errors_from
        end
      end
    end
  end
end
