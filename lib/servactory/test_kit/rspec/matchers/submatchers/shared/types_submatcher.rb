# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Matchers
        module Submatchers
          module Shared
            # Submatcher for validating attribute type definitions.
            #
            # ## Purpose
            #
            # Validates that an attribute (input, internal, or output) has the
            # expected type or types defined. Supports multiple types for union types.
            #
            # ## Usage
            #
            # ```ruby
            # it { is_expected.to have_service_input(:user_id).type(Integer) }
            # it { is_expected.to have_service_input(:data).types(String, Hash) }
            # it { is_expected.to have_service_internal(:result).type(Array) }
            # ```
            #
            # ## Comparison
            #
            # Types are compared by name, sorted alphabetically. Order of types
            # in the definition doesn't matter - only the set of types must match.
            class TypesSubmatcher < Base::Submatcher
              # Creates a new types submatcher.
              #
              # @param context [Base::SubmatcherContext] The submatcher context
              # @param expected_types [Array<Class>] Expected type classes
              # @return [TypesSubmatcher] New submatcher instance
              def initialize(context, expected_types)
                super(context)
                @expected_types = expected_types
              end

              # Returns description for RSpec output.
              #
              # @return [String] Human-readable description with type names
              def description
                "type(s): #{expected_types.map(&:name).join(', ')}"
              end

              protected

              # Checks if the attribute types match expected types.
              #
              # @return [Boolean] True if types match (order-independent)
              def passes?
                actual_types = attribute_data.fetch(:types)
                @actual_types = actual_types

                expected_types.sort_by(&:name) == actual_types.sort_by(&:name)
              end

              # Builds the failure message for type validation.
              #
              # @return [String] Failure message with expected vs actual types
              def build_failure_message
                <<~MESSAGE.squish
                  should have type(s) #{expected_types.map(&:name).join(', ')}
                  but got #{@actual_types.map(&:name).join(', ')}
                MESSAGE
              end

              private

              attr_reader :expected_types
            end
          end
        end
      end
    end
  end
end
