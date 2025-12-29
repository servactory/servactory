# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Matchers
        module Submatchers
          module Shared
            # Submatcher for validating target constraints.
            #
            # ## Purpose
            #
            # Validates that an attribute has the expected target values defined.
            # Targets are similar to inclusions but can be named differently
            # (e.g., :target, :category, :group).
            #
            # ## Usage
            #
            # ```ruby
            # it { is_expected.to have_service_input(:category).target([Category::A, Category::B], name: :category) }
            # it { is_expected.to have_service_input(:type).target(%i[user admin], name: :type) }
            # ```
            #
            # ## Comparison
            #
            # Uses set difference to compare values - order doesn't matter.
            # Supports both single values and arrays.
            class TargetSubmatcher < Base::Submatcher
              # Key for the target values within the option
              OPTION_BODY_KEY = :in

              # Creates a new target submatcher.
              #
              # @param context [Base::SubmatcherContext] The submatcher context
              # @param option_name [Symbol] The name of the target option
              # @param values [Array] Expected target values
              # @return [TargetSubmatcher] New submatcher instance
              def initialize(context, option_name, values)
                super(context)
                @option_name = option_name
                @values = values
              end

              # Returns description for RSpec output.
              #
              # @return [String] Human-readable description with target values
              def description
                "#{option_name}: #{formatted_values}"
              end

              protected

              # Checks if the target values match expected values.
              #
              # @return [Boolean] True if target values match (order-independent)
              def passes?
                return false unless attribute_target.is_a?(Hash)
                return false if attribute_target_in.nil?

                expected = normalize_to_array(values)
                actual = normalize_to_array(attribute_target_in)

                actual.difference(expected).empty? && expected.difference(actual).empty?
              end

              # Builds the failure message for target validation.
              #
              # @return [String] Failure message with expected vs actual values
              def build_failure_message
                <<~MESSAGE
                  should include the expected #{option_name} values

                    expected #{values.inspect}
                         got #{attribute_target_in.inspect}
                MESSAGE
              end

              private

              attr_reader :option_name,
                          :values

              # Formats values for human-readable description.
              #
              # @return [String] Comma-separated formatted values
              def formatted_values
                values.map do |value|
                  case value
                  when nil then "nil"
                  when Class then value.name
                  else value.to_s
                  end
                end.join(", ")
              end

              # Fetches the target option from attribute data.
              #
              # @return [Hash, nil] The target option or nil
              def attribute_target
                @attribute_target ||= attribute_data[option_name]
              end

              # Fetches the target values array from the option.
              #
              # @return [Array, Object, nil] The target values or nil
              def attribute_target_in
                return @attribute_target_in if defined?(@attribute_target_in)

                @attribute_target_in = attribute_target&.dig(OPTION_BODY_KEY)
              end

              # Normalizes a value to an array for comparison.
              #
              # @param value [Object] Value to normalize
              # @return [Array] Wrapped value or original array
              def normalize_to_array(value)
                value.respond_to?(:difference) ? value : [value]
              end
            end
          end
        end
      end
    end
  end
end
