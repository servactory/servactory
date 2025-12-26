# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Matchers
        module Result
          class BeSuccessServiceMatcher
            include RSpec::Matchers::Composable

            def initialize
              @expected_outputs = {}
            end

            def supports_block_expectations?
              false
            end

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

            def description
              "service success"
            end

            def failure_message # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity
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

            def failure_message_when_negated
              "Expected result not to be a successful service"
            end

            # Chain methods
            def with_output(key, value)
              expected_outputs[key] = value
              self
            end

            def with_outputs(attributes)
              attributes.each { |key, value| expected_outputs[key] = value }
              self
            end

            private

            attr_reader :result, :expected_outputs
          end
        end
      end
    end
  end
end
