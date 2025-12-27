# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Helpers
        module Concerns
          module ErrorMessages
            private

            def invalid_service_class_message(given)
              <<~MESSAGE.squish
                Invalid service class provided to service mock helper.
                Expected a class responding to `.call` and `.call!`,
                got: #{given.inspect} (#{given.class.name}).
                Hint: Ensure you're passing the service class, not an instance.
                Example: allow_service(MyService).as_success
              MESSAGE
            end

            def invalid_block_return_message(given, expected_type)
              <<~MESSAGE.squish
                Invalid block return value in service mock helper.
                Expected: #{expected_type},
                got: #{given.class.name}.
                Example for success: allow_service_as_success!(MyService) { { user_id: 123 } }
              MESSAGE
            end

            def unknown_outputs_message(service_class:, unknown_outputs:, defined_outputs:)
              <<~MESSAGE.squish
                Unknown output(s) for #{service_class.name}:
                provided: #{unknown_outputs.map(&:inspect).join(", ")},
                defined: #{defined_outputs.map(&:inspect).join(", ")}.
                Hint: Check that the output names match the service definition.
              MESSAGE
            end

            def type_mismatch_message(service_class:, output_name:, expected_types:, actual_value:)
              <<~MESSAGE.squish
                Type mismatch for output :#{output_name} in #{service_class.name}.
                Expected: #{expected_types.map(&:name).join(" or ")},
                got: #{actual_value.class.name} (#{actual_value.inspect}).
                Hint: Ensure the mocked value matches the expected type.
              MESSAGE
            end

            def missing_result_type_message
              <<~MESSAGE.squish
                Result type not specified.
                Use .as_success or .as_failure to specify the mock result type.
                Example: allow_service(MyService).as_success.with_outputs(data: "value")
              MESSAGE
            end
          end
        end
      end
    end
  end
end
