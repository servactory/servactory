# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Helpers
        module Concerns
          # Concern providing error message builders for service mock helpers.
          #
          # ## Purpose
          #
          # ErrorMessages provides standardized, helpful error messages for common
          # issues in service mocking. Each message includes context about what went
          # wrong, hints for fixing the issue, and code examples.
          #
          # ## Usage
          #
          # Include in helper classes that need to report errors:
          #
          # ```ruby
          # class ServiceMockBuilder
          #   include Concerns::ErrorMessages
          #
          #   def validate!
          #     raise ArgumentError, missing_exception_for_failure_message(service_class)
          #   end
          # end
          # ```
          #
          # ## Message Categories
          #
          # - Service class validation errors
          # - Block return value errors
          # - Output validation errors
          # - Type mismatch errors
          # - Result type configuration errors
          # - Exception configuration errors
          module ErrorMessages
            private

            # Builds error message for invalid service class.
            #
            # @param given [Object] The invalid value that was provided
            # @return [String] Error message with hint and example
            def invalid_service_class_message(given)
              <<~MESSAGE.squish
                Invalid service class provided to service mock helper.
                Expected a class responding to `.call` and `.call!`,
                got: #{given.inspect} (#{given.class.name}).
                Hint: Ensure you're passing the service class, not an instance.
                Example: allow_service(MyService).as_success
              MESSAGE
            end

            # Builds error message for invalid block return value.
            #
            # @param given [Object] The actual return value
            # @param expected_type [String] Description of expected type
            # @return [String] Error message with example
            def invalid_block_return_message(given, expected_type)
              <<~MESSAGE.squish
                Invalid block return value in service mock helper.
                Expected: #{expected_type},
                got: #{given.class.name}.
                Example for success: allow_service_as_success!(MyService) { { user_id: 123 } }
              MESSAGE
            end

            # Builds error message for unknown output names.
            #
            # @param service_class [Class] The service class
            # @param unknown_outputs [Array<Symbol>] Outputs not defined in service
            # @param defined_outputs [Array<Symbol>] Valid output names
            # @return [String] Error message with hint
            def unknown_outputs_message(service_class:, unknown_outputs:, defined_outputs:)
              <<~MESSAGE.squish
                Unknown output(s) for #{service_class.name}:
                provided: #{unknown_outputs.map(&:inspect).join(', ')},
                defined: #{defined_outputs.map(&:inspect).join(', ')}.
                Hint: Check that the output names match the service definition.
              MESSAGE
            end

            # Builds error message for output type mismatch.
            #
            # @param service_class [Class] The service class
            # @param output_name [Symbol] Name of the mismatched output
            # @param expected_types [Array<Class>] Expected type classes
            # @param actual_value [Object] The value with wrong type
            # @return [String] Error message with hint
            def type_mismatch_message(service_class:, output_name:, expected_types:, actual_value:)
              <<~MESSAGE.squish
                Type mismatch for output :#{output_name} in #{service_class.name}.
                Expected: #{expected_types.map(&:name).join(' or ')},
                got: #{actual_value.class.name} (#{actual_value.inspect}).
                Hint: Ensure the mocked value matches the expected type.
              MESSAGE
            end

            # Builds error message for missing result type.
            #
            # @return [String] Error message with example
            def missing_result_type_message
              <<~MESSAGE.squish
                Result type not specified.
                Use .as_success or .as_failure to specify the mock result type.
                Example: allow_service(MyService).as_success.with_outputs(data: "value")
              MESSAGE
            end

            # Builds error message for failure mock missing exception.
            #
            # @param service_class [Class] The service class
            # @return [String] Error message with example showing full signature
            def missing_exception_for_failure_message(service_class)
              <<~MESSAGE.squish
                Exception is required for failure mock of #{service_class.name}.
                Servactory supports custom exception classes via configuration,
                so you must explicitly specify the exception.
                Example:
                  allow_service(#{service_class.name})
                    .as_failure
                    .with_exception(Servactory::Exceptions::Failure.new(message: "..."))
                Full signature: .new(type: :custom_type, message: "...", meta: { key: :value })
              MESSAGE
            end

            # Builds error message for wrong exception type.
            #
            # @param service_class [Class] The service class
            # @param expected_class [Class] The configured failure class
            # @param actual_class [Class] The provided exception's class
            # @return [String] Error message with hint and example
            def invalid_exception_type_message(service_class:, expected_class:, actual_class:) # rubocop:disable Metrics/MethodLength
              <<~MESSAGE.squish
                Invalid exception type for failure mock of #{service_class.name}.
                Expected: instance of #{expected_class.name} (configured failure_class),
                got: #{actual_class.name}.
                Hint: Use the service's configured failure class or its subclass.
                Example:
                  allow_service(#{service_class.name})
                    .as_failure
                    .with_exception(#{expected_class.name}.new(message: "..."))
                Full signature: .new(type: :custom_type, message: "...", meta: { key: :value })
              MESSAGE
            end
          end
        end
      end
    end
  end
end
