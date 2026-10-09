# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Matchers
        module Base
          # Message expected by a test for an attribute option.
          #
          # ## Purpose
          #
          # MessageExpectation compares the message defined for an attribute
          # option with the message expected by a test and explains a mismatch.
          # Submatchers that check messages share it, so every message
          # assertion follows the same rules.
          #
          # ## Comparison
          #
          # - String - equals the message text exactly
          # - Regexp - matches the message text
          # - RSpec matcher - matches the message as defined, for example a Proc
          # - `:default` - the option defines no custom message, so the
          #   library uses its default message
          #
          # A Proc message is built before a String or Regexp comparison.
          # A Proc that raises or returns an object other than a String
          # does not match.
          #
          # Without a custom message, a String or Regexp is compared with the
          # default message only if it is known before the service runs.
          # Otherwise the check fails, because the default message depends
          # on values such as the given value.
          #
          # ## Usage
          #
          # ```ruby
          # expectation = MessageExpectation.new(/must be/)
          # expectation.mismatch_for(message) { |proc_message| proc_message.call(value: nil) }
          # # => nil when the message matches, otherwise the explanation
          # ```
          class MessageExpectation
            # Expected value meaning that the option defines no custom message
            DEFAULT = :default

            # @return [String, Regexp, Symbol, Object] The expected message, `:default` or an RSpec matcher
            attr_reader :expected

            # Creates a new message expectation.
            #
            # @param expected [String, Regexp, Symbol, Object] The expected message, `:default` or an RSpec matcher
            # @return [MessageExpectation] New expectation instance
            # @raise [ArgumentError] If the expected message is of another kind
            def initialize(expected)
              @expected = expected

              return if default? || expected.is_a?(String) || expected.is_a?(Regexp) || matcher?

              raise ArgumentError,
                    "Expected message must be a String, a Regexp, an RSpec matcher or :default, " \
                    "got #{expected.inspect}"
            end

            # Describes the expected message for descriptions and failure messages.
            #
            # @return [String] The expected message or the description of the matcher
            def description
              return "the default message" if default?
              return expected.description if matcher? && expected.respond_to?(:description)

              expected.inspect
            end

            # Checks the message defined for the option.
            #
            # @param message [String, Proc, nil] The message defined for the option
            # @param default_message [String, Proc, nil] The message used when the option defines none,
            #   or nil if it depends on values known only while the service runs
            # @yieldparam message [Proc] A Proc message to build
            # @yieldreturn [Object] The built message
            # @return [String, nil] Explanation of the mismatch, or nil if the message matches
            def mismatch_for(message, default_message: nil, &block)
              return default_mismatch_for(message) if default?
              return matcher_mismatch_for(message) if matcher?
              return runtime_default_explanation if message.blank? && default_message.nil?

              text_mismatch_for(message.presence || default_message, &block)
            end

            private

            # Checks whether the default message is expected.
            #
            # @return [Boolean] True for `:default`
            def default?
              expected == DEFAULT
            end

            # Checks that the option defines no custom message.
            #
            # @param message [String, Proc, nil] The message defined for the option
            # @return [String, nil] Explanation of the mismatch, or nil if there is no custom message
            def default_mismatch_for(message)
              return if message.blank?

              <<~MESSAGE
                expected #{description}
                     got the custom message #{message.inspect}
              MESSAGE
            end

            # Checks whether the expected message is an RSpec matcher.
            #
            # @return [Boolean] True for RSpec matchers
            def matcher?
              RSpec::Matchers.is_a_matcher?(expected)
            end

            # Applies the RSpec matcher to the message as defined.
            #
            # @param message [String, Proc, nil] The message defined for the option
            # @return [String, nil] Explanation of the mismatch, or nil if the message matches
            def matcher_mismatch_for(message)
              return if expected.matches?(message)

              diff_explanation(message)
            end

            # Compares the message text with the expected String or Regexp.
            #
            # @param message [String, Proc, nil] The message to compare
            # @yieldparam message [Proc] A Proc message to build
            # @return [String, nil] Explanation of the mismatch, or nil if the message matches
            def text_mismatch_for(message)
              text = message.is_a?(Proc) ? yield(message) : message
            rescue StandardError => e
              proc_error_explanation(e)
            else
              return "#{diff_explanation(text).chomp}, which is not a String\n" unless text.is_a?(String)

              diff_explanation(text) unless text_matches?(text)
            end

            # Compares a message text with the expected String or Regexp.
            #
            # @param text [String] The message text
            # @return [Boolean] True if the text matches
            def text_matches?(text)
              expected.is_a?(Regexp) ? expected.match?(text) : expected == text
            end

            # Explains a mismatch with the expected and the actual message.
            #
            # @param actual [Object] The actual message
            # @return [String] Explanation of the mismatch
            def diff_explanation(actual)
              <<~MESSAGE
                expected #{description}
                     got #{actual.inspect}
              MESSAGE
            end

            # Explains why a String or Regexp cannot be checked without a custom message.
            #
            # @return [String] Explanation of the mismatch
            def runtime_default_explanation
              <<~MESSAGE
                expected #{description}
                     got no custom message

                The default message depends on values known only while the service runs.
                Use `message(:default)` to check that no custom message is defined,
                or check the error message with `raise_error`.
              MESSAGE
            end

            # Explains an error raised while building a Proc message.
            #
            # @param error [StandardError] The raised error
            # @return [String] Explanation of the error
            def proc_error_explanation(error)
              <<~MESSAGE
                could not build the Proc message to compare with #{description}:
                  #{error.class}: #{error.message}

                The Proc receives every keyword the library passes to it while the service runs,
                with nil for values known only then, such as `value:`. Accept unused keywords with `**`.
              MESSAGE
            end
          end
        end
      end
    end
  end
end
