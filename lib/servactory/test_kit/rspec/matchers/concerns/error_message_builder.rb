# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Matchers
        module Concerns
          # Concern providing helper methods for building error messages in submatchers.
          #
          # ## Purpose
          #
          # ErrorMessageBuilder provides consistent formatting methods for constructing
          # readable failure messages. It handles diff-style messages showing expected
          # vs actual values, and list formatting.
          #
          # ## Usage
          #
          # Include in submatcher classes:
          #
          # ```ruby
          # class TypesSubmatcher < Base::Submatcher
          #   include Concerns::ErrorMessageBuilder
          #
          #   def build_failure_message
          #     build_diff_message(
          #       expected: [String, Integer],
          #       actual: [Boolean],
          #       prefix: "type mismatch"
          #     )
          #   end
          # end
          # ```
          #
          # ## Methods Provided
          #
          # - `build_diff_message` - creates expected/got diff output
          # - `format_value` - formats values for display (handles Arrays, Classes, etc.)
          # - `build_list_message` - formats item lists with optional prefix
          module ErrorMessageBuilder
            # Includes InstanceMethods in the including class.
            #
            # @param base [Class] The class including this concern
            # @return [void]
            def self.included(base)
              base.include(InstanceMethods)
            end

            # Instance methods added by this concern.
            module InstanceMethods
              # Builds a diff-style message showing expected vs actual values.
              #
              # @param expected [Object] The expected value
              # @param actual [Object] The actual value found
              # @param prefix [String] Optional prefix text before the diff
              # @return [String] Formatted diff message
              def build_diff_message(expected:, actual:, prefix: "")
                <<~MESSAGE
                  #{prefix}
                    expected: #{format_value(expected)}
                         got: #{format_value(actual)}
                MESSAGE
              end

              # Formats a value for human-readable display.
              #
              # Handles special cases:
              # - Arrays: formats each element recursively
              # - Hashes: uses inspect
              # - Classes: shows class name
              # - nil: shows "nil" string
              # - Others: uses inspect
              #
              # @param value [Object] The value to format
              # @return [String] Formatted string representation
              def format_value(value) # rubocop:disable Metrics/MethodLength
                case value
                when Array
                  "[#{value.map { |v| format_value(v) }.join(', ')}]"
                when Hash
                  value.inspect
                when Class
                  value.name
                when nil
                  "nil"
                else # rubocop:disable Lint/DuplicateBranch
                  value.inspect
                end
              end

              # Builds a comma-separated list message.
              #
              # @param items [Array] Items to list
              # @param prefix [String] Optional prefix before the list
              # @return [String] Formatted list or "(empty)" if no items
              def build_list_message(items, prefix: "")
                return "#{prefix}(empty)" if items.empty?

                "#{prefix}#{items.join(', ')}"
              end
            end
          end
        end
      end
    end
  end
end
