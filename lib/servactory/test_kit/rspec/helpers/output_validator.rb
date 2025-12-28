# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Helpers
        # Validates mock output values against service definitions.
        #
        # ## Purpose
        #
        # Ensures that mocked output values match the service's output
        # definitions in terms of names and types. Helps catch configuration
        # errors early in tests.
        #
        # ## Usage
        #
        # Called automatically when `validate_outputs!` is used on builder:
        #
        # ```ruby
        # allow_service(MyService)
        #   .as_success
        #   .outputs(user: user)
        #   .validate_outputs!
        # ```
        #
        # Can also be called directly:
        #
        # ```ruby
        # OutputValidator.validate!(
        #   service_class: MyService,
        #   outputs: { user: user }
        # )
        # ```
        #
        # ## Validations
        #
        # 1. **Output names** - all provided outputs must be defined in service
        # 2. **Output types** - values must match expected types (if defined)
        class OutputValidator
          include Concerns::ErrorMessages

          # Error raised when validation fails
          class ValidationError < StandardError; end

          class << self
            # Validates outputs and raises on failure.
            #
            # @param service_class [Class] The service class
            # @param outputs [Hash] Output values to validate
            # @raise [ValidationError] If validation fails
            # @return [void]
            def validate!(service_class:, outputs:)
              new(service_class:, outputs:).validate!
            end
          end

          # Creates a new validator instance.
          #
          # @param service_class [Class] The service class
          # @param outputs [Hash] Output values to validate
          # @return [OutputValidator] New validator
          def initialize(service_class:, outputs:)
            @service_class = service_class
            @outputs = outputs
          end

          # Runs all validations.
          #
          # @raise [ValidationError] If any validation fails
          # @return [void]
          def validate!
            validate_output_names!
            validate_output_types!
          end

          private

          # Validates all output names are defined in service.
          #
          # @raise [ValidationError] If unknown output names provided
          # @return [void]
          def validate_output_names!
            defined_outputs = @service_class.info.outputs.keys
            provided_outputs = @outputs.keys

            unknown_outputs = provided_outputs - defined_outputs

            return if unknown_outputs.empty?

            raise ValidationError, unknown_outputs_message(
              service_class: @service_class,
              unknown_outputs:,
              defined_outputs:
            )
          end

          # Validates output values match expected types.
          #
          # @raise [ValidationError] If type mismatch found
          # @return [void]
          def validate_output_types! # rubocop:disable Metrics/MethodLength
            @outputs.each do |name, value|
              output_info = @service_class.info.outputs[name]
              next unless output_info

              expected_types = output_info[:types]
              next if value.nil?
              next if expected_types.nil? || expected_types.empty?
              next if expected_types.any? { |type| value.is_a?(type) }

              raise ValidationError, type_mismatch_message(
                service_class: @service_class,
                output_name: name,
                expected_types:,
                actual_value: value
              )
            end
          end
        end
      end
    end
  end
end
