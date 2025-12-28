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
                "inclusion: #{values.join(', ')}"
              end

              protected

              # Checks if the inclusion values match expected values.
              #
              # @return [Boolean] True if inclusion values match (order-independent)
              def passes?
                return false unless attribute_inclusion.is_a?(Hash)
                return false if attribute_inclusion_in.nil?

                attribute_inclusion_in.difference(values).empty? &&
                  values.difference(attribute_inclusion_in).empty?
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
              # @return [Array, nil] The allowed values or nil
              def attribute_inclusion_in
                return @attribute_inclusion_in if defined?(@attribute_inclusion_in)

                @attribute_inclusion_in = attribute_inclusion&.dig(OPTION_BODY_KEY)
              end
            end
          end
        end
      end
    end
  end
end
