# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Matchers
        module Result
          # RSpec matcher for validating failed service results.
          #
          # ## Purpose
          #
          # Validates that a service result is a failure with expected error type,
          # message, and metadata. Supports custom failure classes configured via
          # Servactory settings.
          #
          # ## Usage
          #
          # ```ruby
          # RSpec.describe MyService, type: :service do
          #   it "fails with validation error" do
          #     result = described_class.call(invalid: true)
          #
          #     expect(result).to be_failure_service
          #       .type(:validation_error)
          #       .message("Invalid input provided")
          #   end
          #
          #   it "fails with custom exception and meta" do
          #     result = described_class.call(bad_data: true)
          #
          #     expect(result).to be_failure_service
          #       .with(MyCustomFailure)
          #       .type(:processing_error)
          #       .meta(field: :data, code: 422)
          #   end
          # end
          # ```
          #
          # ## Chain Methods
          #
          # - `.with(Class)` - expected custom failure class
          # - `.type(Symbol)` - expected error type (defaults to `:base`)
          # - `.message(String)` - expected error message
          # - `.meta(Hash)` - expected error metadata
          #
          # ## Validation Steps
          #
          # 1. Checks result is a `Servactory::Result` instance
          # 2. Verifies `result.success?` returns false
          # 3. Verifies `result.failure?` returns true
          # 4. Validates error is a `Servactory::Exceptions::Failure`
          # 5. Validates failure class if specified via `.with`
          # 6. Validates error type (defaults to `:base`)
          # 7. Validates message if specified
          # 8. Validates meta if specified
          class BeFailureServiceMatcher # rubocop:disable Metrics/ClassLength
            include RSpec::Matchers::Composable

            # Creates a new failure matcher with empty expectations.
            #
            # @return [BeFailureServiceMatcher] New matcher instance
            def initialize
              @expected_failure_class = nil
              @expected_type = nil
              @expected_message = nil
              @expected_meta = nil
              @type_defined = false
              @message_defined = false
              @meta_defined = false
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
            # @return [Boolean] True if result is failure with matching error attributes
            def matches?(result) # rubocop:disable Metrics/MethodLength, Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
              @result = result

              failure_class = expected_failure_class || Servactory::Exceptions::Failure
              type = @type_defined ? expected_type : :base

              matched = result.is_a?(Servactory::Result)
              matched &&= !result.success?
              matched &&= result.failure?
              matched &&= result.error.is_a?(Servactory::Exceptions::Failure)
              matched &&= result.error.is_a?(failure_class)
              matched &&= result.error.type == type
              matched &&= result.error.message == expected_message if @message_defined
              matched &&= result.error.meta == expected_meta if @meta_defined

              matched
            end

            # Returns a description of what this matcher validates.
            #
            # @return [String] Human-readable matcher description
            def description
              "service failure"
            end

            # Returns detailed failure message explaining what check failed.
            #
            # Checks in order: result type, failure status, error class, failure class,
            # error type, message, and meta.
            #
            # @return [String] Detailed failure message with expected vs actual
            def failure_message # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity
              unless result.is_a?(Servactory::Result)
                return <<~MESSAGE
                  Incorrect service result:

                    expected Servactory::Result
                         got #{result.class.name}
                MESSAGE
              end

              if result.success?
                return <<~MESSAGE
                  Incorrect service result:

                    expected failure
                         got success
                MESSAGE
              end

              unless result.error.is_a?(Servactory::Exceptions::Failure)
                return <<~MESSAGE
                  Incorrect error object:

                    expected Servactory::Exceptions::Failure
                         got #{result.error.class.name}
                MESSAGE
              end

              if expected_failure_class && !result.error.is_a?(expected_failure_class)
                return <<~MESSAGE
                  Incorrect instance error:

                    expected #{expected_failure_class}
                         got #{result.error.class.name}
                MESSAGE
              end

              expected_type_value = @type_defined ? expected_type : :base
              if result.error.type != expected_type_value
                return <<~MESSAGE
                  Incorrect error type:

                    expected #{expected_type_value.inspect}
                         got #{result.error.type.inspect}
                MESSAGE
              end

              if @message_defined && result.error.message != expected_message
                return <<~MESSAGE
                  Incorrect error message:

                    expected #{expected_message.inspect}
                         got #{result.error.message.inspect}
                MESSAGE
              end

              if @meta_defined && result.error.meta != expected_meta
                return <<~MESSAGE
                  Incorrect error meta:

                    expected #{expected_meta.inspect}
                         got #{result.error.meta.inspect}
                MESSAGE
              end

              <<~MESSAGE
                Unexpected case when using `be_failure_service`.

                Exception:  #{result.error.inspect}
                Type:       #{result.error.type.inspect}
                Message:    #{result.error.message.inspect}
                Meta:       #{result.error.meta.inspect}

                Please try to build an example based on the documentation.
                Or report your problem to us:

                  https://github.com/servactory/servactory/issues
              MESSAGE
            end

            # Returns the failure message for negated expectations.
            #
            # @return [String] Negated failure message
            def failure_message_when_negated
              "Expected result not to be a failed service"
            end

            # Chain Methods
            # -------------

            # Specifies the expected custom failure class.
            #
            # Use when service is configured with a custom failure_class.
            #
            # @param failure_class [Class] Expected failure exception class
            # @return [self] For method chaining
            def with(failure_class)
              @expected_failure_class = failure_class
              self
            end

            # Specifies the expected error type.
            #
            # @param expected_type [Symbol] Expected type (defaults to :base if not set)
            # @return [self] For method chaining
            def type(expected_type)
              @expected_type = expected_type
              @type_defined = true
              self
            end

            # Specifies the expected error message.
            #
            # @param expected_message [String] Expected error message text
            # @return [self] For method chaining
            def message(expected_message)
              @expected_message = expected_message
              @message_defined = true
              self
            end

            # Specifies the expected error metadata.
            #
            # @param expected_meta [Hash] Expected meta hash
            # @return [self] For method chaining
            def meta(expected_meta)
              @expected_meta = expected_meta
              @meta_defined = true
              self
            end

            private

            attr_reader :result,
                        :expected_failure_class,
                        :expected_type,
                        :expected_message,
                        :expected_meta
          end
        end
      end
    end
  end
end
