# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Matchers
        module Result
          # RSpec matcher for validating successful service results.
          #
          # ## Purpose
          #
          # Validates that a service result is successful and optionally contains
          # expected output values. Used in integration tests to verify service
          # execution completed without failure.
          #
          # ## Usage
          #
          # ```ruby
          # RSpec.describe MyService, type: :service do
          #   it "succeeds with expected outputs" do
          #     result = described_class.call(user_id: 123)
          #
          #     expect(result).to be_success_service
          #       .with_output(:user_name, "John")
          #       .with_output(:status, "active")
          #   end
          #
          #   it "succeeds with multiple outputs" do
          #     result = described_class.call(data: input_data)
          #
          #     expect(result).to be_success_service
          #       .with_outputs(processed: true, count: 5)
          #   end
          # end
          # ```
          #
          # ## Chain Methods
          #
          # - `.with_output(key, value)` - validates single output value
          # - `.with_outputs(hash)` - validates multiple output values at once
          #
          # ## Validation Steps
          #
          # 1. Checks result is a `Servactory::Result` instance
          # 2. Verifies `result.success?` returns true
          # 3. Verifies `result.failure?` returns false
          # 4. Validates all expected outputs match actual values
          class BeSuccessServiceMatcher
            include RSpec::Matchers::Composable

            # Creates a new success matcher with empty output expectations.
            #
            # @return [BeSuccessServiceMatcher] New matcher instance
            def initialize
              @expected_outputs = {}
            end

            # Indicates this matcher does not support block expectations.
            #
            # @return [Boolean] Always false
            def supports_block_expectations?
              false
            end

            # Performs the match against the actual service result.
            #
            # @param result [Servactory::Result] The service result to validate
            # @return [Boolean] True if result is successful with matching outputs
            def matches?(result)
              @result = result

              matched = result.is_a?(Servactory::Result)
              matched &&= result.success?
              matched &&= !result.failure?

              matched &&= expected_outputs.all? do |key, value|
                result.respond_to?(key) && result.public_send(key) == value
              end

              matched
            end

            # Returns a description of what this matcher validates.
            #
            # @return [String] Human-readable matcher description
            def description
              "service success"
            end

            # Returns detailed failure message explaining what check failed.
            #
            # Checks in order: result type, success status, output existence, output values.
            #
            # @return [String] Detailed failure message
            def failure_message # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength
              unless result.is_a?(Servactory::Result)
                return <<~MESSAGE
                  Incorrect service result:

                    expected Servactory::Result
                         got #{result.class.name}
                MESSAGE
              end

              if result.failure?
                return <<~MESSAGE
                  Incorrect service result:

                    expected success
                         got failure
                MESSAGE
              end

              message = expected_outputs.each do |key, value|
                unless result.respond_to?(key)
                  break <<~MESSAGE
                    Non-existent value key in result:

                    expected #{result.inspect}
                         got #{key}
                  MESSAGE
                end

                received_value = result.public_send(key)
                next if received_value == value

                break <<~MESSAGE
                  Incorrect result value for #{key}:

                    expected #{value.inspect}
                         got #{received_value.inspect}
                MESSAGE
              end

              return message if message.present? && message.is_a?(String)

              <<~MESSAGE
                Unexpected case when using `be_success_service`.

                Please try to build an example based on the documentation.
                Or report your problem to us:

                  https://github.com/servactory/servactory/issues
              MESSAGE
            end

            # Returns the failure message for negated expectations.
            #
            # @return [String] Negated failure message
            def failure_message_when_negated
              "Expected result not to be a successful service"
            end

            # Chain Methods
            # -------------

            # Specifies an expected output value on the result.
            #
            # @param key [Symbol] Output attribute name
            # @param value [Object] Expected value
            # @return [self] For method chaining
            def with_output(key, value)
              expected_outputs[key] = value
              self
            end

            # Specifies multiple expected output values at once.
            #
            # @param attributes [Hash{Symbol => Object}] Expected output key-value pairs
            # @return [self] For method chaining
            def with_outputs(attributes)
              attributes.each { |key, value| expected_outputs[key] = value }
              self
            end

            private

            attr_reader :result,
                        :expected_outputs
          end
        end
      end
    end
  end
end
