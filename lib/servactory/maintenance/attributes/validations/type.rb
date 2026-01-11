# frozen_string_literal: true

module Servactory
  module Maintenance
    module Attributes
      module Validations
        class Type
          extend Concerns::ErrorBuilder

          # Validates attribute type without instance allocation.
          #
          # Optimized for the common case (validation success) with zero allocations.
          # Returns error message string on failure, nil on success.
          #
          # @param context [Object] Service context
          # @param attribute [Inputs::Input, Internals::Internal, Outputs::Output] Attribute to validate
          # @param value [Object] Value to validate
          # @param check_key [Symbol] Validation check key
          # @return [String, nil] nil on success, error message on failure
          def self.check(context:, attribute:, value:, check_key:, **)
            return unless should_be_checked_for?(attribute, value, check_key)

            prepared_value = compute_prepared_value(attribute, value)

            error_data = Servactory::Maintenance::Validations::Types.validate(
              context:,
              attribute:,
              types: attribute.types,
              value: prepared_value
            )

            return if error_data.nil?

            build_error_message(error_data)
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

          # Builds error message from validation error data.
          #
          # @param error_data [Hash] Error data from Types.validate
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
