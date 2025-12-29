# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Matchers
        module Submatchers
          module Shared
            # Submatcher for validating inclusion constraints.
            #
            # ## Purpose
            #
            # Validates that an attribute has the expected inclusion values.
            # Inclusion restricts attribute values to a specific set of allowed values.
            #
            # ## Usage
            #
            # ```ruby
            # it { is_expected.to have_service_input(:status).inclusion(%w[active inactive pending]) }
            # it { is_expected.to have_service_input(:priority).inclusion([1, 2, 3]) }
            # ```
            #
            # ## Comparison
            #
            # Uses set difference to compare values - order doesn't matter,
            # only the set of allowed values must match exactly.
            class InclusionSubmatcher < Base::Submatcher
              # Option name in attribute data
              OPTION_NAME = :inclusion
              # Key for the inclusion values within the option
              OPTION_BODY_KEY = :in

              # Creates a new inclusion submatcher.
              #
              # @param context [Base::SubmatcherContext] The submatcher context
              # @param values [Array] Expected allowed values
              # @return [InclusionSubmatcher] New submatcher instance
              def initialize(context, values)
                super(context)
                @values = values
              end

              # Returns description for RSpec output.
              #
              # @return [String] Human-readable description with values
              def description
                formatted = case values
                            when Range then values.inspect
                            else values.join(', ')
                            end
                "inclusion: #{formatted}"
              end

              protected

              # Checks if the inclusion values match expected values.
              #
              # @return [Boolean] True if inclusion values match
              def passes?
                return false unless attribute_inclusion.is_a?(Hash)
                return false if attribute_inclusion_in.nil?

                compare_inclusion_values(attribute_inclusion_in, values)
              end

              # Builds the failure message for inclusion validation.
              #
              # @return [String] Failure message with expected vs actual values
              def build_failure_message
                <<~MESSAGE
                  should include the expected values

                    expected #{values.inspect}
                         got #{attribute_inclusion_in.inspect}
                MESSAGE
              end

              private

              attr_reader :values

              # Fetches the inclusion option from attribute data.
              #
              # @return [Hash, nil] The inclusion option or nil
              def attribute_inclusion
                @attribute_inclusion ||= attribute_data[OPTION_NAME]
              end

              # Fetches the inclusion values array from the option.
              #
              # @return [Array, Range, nil] The allowed values or nil
              def attribute_inclusion_in
                return @attribute_inclusion_in if defined?(@attribute_inclusion_in)

                @attribute_inclusion_in = attribute_inclusion&.dig(OPTION_BODY_KEY)
              end

              # Compares two inclusion values for equality.
              # Supports Range, Array, and mixed types.
              #
              # @param actual [Range, Array] Actual inclusion value
              # @param expected [Range, Array] Expected inclusion value
              # @return [Boolean] True if values are equivalent
              def compare_inclusion_values(actual, expected)
                case [actual.class, expected.class]
                when [Range, Range]
                  actual == expected
                when [Array, Array]
                  actual.difference(expected).empty? && expected.difference(actual).empty?
                else
                  actual.to_s == expected.to_s
                end
              end
            end
          end
        end
      end
    end
  end
end
