# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Helpers
        class OutputValidator
          include Concerns::ErrorMessages

          class ValidationError < StandardError; end

          class << self
            def validate!(service_class:, outputs:)
              new(service_class:, outputs:).validate!
            end
          end

          def initialize(service_class:, outputs:)
            @service_class = service_class
            @outputs = outputs
          end

          def validate!
            validate_output_names!
            validate_output_types!
          end

          private

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

          def validate_output_types! # rubocop:disable Metrics/MethodLength
            @outputs.each do |name, value|
              output_info = @service_class.info.outputs[name]
              next unless output_info

              expected_types = output_info.types
              next if value.nil?
              next if expected_types.empty?
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
