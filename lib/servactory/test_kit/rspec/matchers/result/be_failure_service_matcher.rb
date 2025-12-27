# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Matchers
        module Result
          class BeFailureServiceMatcher # rubocop:disable Metrics/ClassLength
            include RSpec::Matchers::Composable

            def initialize
              @expected_failure_class = nil
              @expected_type = nil
              @expected_message = nil
              @expected_meta = nil
              @type_defined = false
              @message_defined = false
              @meta_defined = false
            end

            def supports_block_expectations?
              false
            end

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

            def description
              "service failure"
            end

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

            def failure_message_when_negated
              "Expected result not to be a failed service"
            end

            # Chain methods
            def with(failure_class)
              @expected_failure_class = failure_class
              self
            end

            def type(expected_type)
              @expected_type = expected_type
              @type_defined = true
              self
            end

            def message(expected_message)
              @expected_message = expected_message
              @message_defined = true
              self
            end

            def meta(expected_meta)
              @expected_meta = expected_meta
              @meta_defined = true
              self
            end

            private

            attr_reader :result, :expected_failure_class, :expected_type,
                        :expected_message, :expected_meta
          end
        end
      end
    end
  end
end
