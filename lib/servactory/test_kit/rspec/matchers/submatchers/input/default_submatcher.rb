# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Matchers
        module Submatchers
          module Input
            # Submatcher for validating input default values.
            #
            # ## Purpose
            #
            # Validates that a service input has the expected default value.
            # Useful for testing optional inputs with predefined fallback values.
            #
            # ## Usage
            #
            # ```ruby
            # it { is_expected.to have_service_input(:limit).default(10) }
            # it { is_expected.to have_service_input(:enabled).default(true) }
            # it { is_expected.to have_service_input(:options).default({}) }
            # ```
            #
            # ## Comparison
            #
            # Uses case-insensitive string comparison for value matching.
            # Handles nil values specially - matches only when expected is also nil.
            class DefaultSubmatcher < Base::Submatcher
              # Creates a new default submatcher.
              #
              # @param context [Base::SubmatcherContext] The submatcher context
              # @param expected_value [Object] The expected default value
              # @return [DefaultSubmatcher] New submatcher instance
              def initialize(context, expected_value)
                super(context)
                @expected_value = expected_value
              end

              # Returns description for RSpec output.
              #
              # @return [String] Human-readable description with expected value
              def description
                "default: #{expected_value.inspect}"
              end

              protected

              # Checks if the input default matches the expected value.
              #
              # @return [Boolean] True if default values match
              def passes?
                actual_default = attribute_data.fetch(:default)
                @actual_value = actual_default

                return expected_value.nil? if actual_default.is_a?(NilClass)

                actual_default.to_s.casecmp(expected_value.to_s).zero?
              end

              # Builds the failure message for default value validation.
              #
              # @return [String] Failure message with expected vs actual
              def build_failure_message
                <<~MESSAGE
                  should have a default value

                    expected #{expected_value.inspect}
                         got #{@actual_value.inspect}
                MESSAGE
              end

              private

              attr_reader :expected_value
            end
          end
        end
      end
    end
  end
end
