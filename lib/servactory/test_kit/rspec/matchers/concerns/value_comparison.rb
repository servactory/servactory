# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Matchers
        module Concerns
          # Concern providing value comparison methods for submatchers.
          #
          # ## Purpose
          #
          # ValueComparison provides flexible comparison methods that handle various
          # types of expected values including RSpec matchers, classes (for type checking),
          # arrays, and plain values.
          #
          # ## Usage
          #
          # Include in submatcher classes:
          #
          # ```ruby
          # class DefaultSubmatcher < Base::Submatcher
          #   include Concerns::ValueComparison
          #
          #   def passes?
          #     values_match?(@expected_default, fetch_option(:default))
          #   end
          # end
          # ```
          #
          # ## Comparison Rules
          #
          # - RSpec matchers (respond_to :matches?) - delegates to matcher
          # - Classes - checks if actual is_a?(expected)
          # - Arrays - element-wise recursive comparison
          # - Other values - uses equality (==)
          module ValueComparison
            # Includes InstanceMethods in the including class.
            #
            # @param base [Class] The class including this concern
            # @return [void]
            def self.included(base)
              base.include(InstanceMethods)
            end

            # Instance methods added by this concern.
            module InstanceMethods
              # Compares expected and actual values with type-aware logic.
              #
              # Supports:
              # - RSpec matchers (anything responding to :matches?)
              # - Class comparison (type checking with is_a?)
              # - Array comparison (recursive element-wise)
              # - Standard equality (==)
              #
              # @param expected [Object] The expected value or matcher
              # @param actual [Object] The actual value to compare
              # @return [Boolean] True if values match
              def values_match?(expected, actual)
                if expected.respond_to?(:matches?)
                  expected.matches?(actual)
                elsif expected.is_a?(Class)
                  actual.is_a?(expected)
                elsif expected.is_a?(Array) && actual.is_a?(Array)
                  arrays_match?(expected, actual)
                else
                  expected == actual
                end
              end

              # Compares two arrays element-by-element.
              #
              # @param expected [Array] Expected array
              # @param actual [Array] Actual array
              # @return [Boolean] True if arrays match (same size and matching elements)
              def arrays_match?(expected, actual)
                return false unless expected.size == actual.size

                expected.zip(actual).all? { |e, a| values_match?(e, a) }
              end

              # Compares two type collections for equality (order-independent).
              #
              # @param expected_types [Array<Class>] Expected type classes
              # @param actual_types [Array<Class>] Actual type classes
              # @return [Boolean] True if same set of types
              def types_match?(expected_types, actual_types)
                expected_set = Set.new(expected_types)
                actual_set = Set.new(actual_types)
                expected_set == actual_set
              end
            end
          end
        end
      end
    end
  end
end
