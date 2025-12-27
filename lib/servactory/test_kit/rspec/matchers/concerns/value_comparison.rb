# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Matchers
        module Concerns
          module ValueComparison
            def self.included(base)
              base.include(InstanceMethods)
            end

            module InstanceMethods
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

              def arrays_match?(expected, actual)
                return false unless expected.size == actual.size

                expected.zip(actual).all? { |e, a| values_match?(e, a) }
              end

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
