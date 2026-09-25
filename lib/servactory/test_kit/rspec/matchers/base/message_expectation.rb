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
          #
          # A Proc message is built before a String or Regexp comparison.
          # A Proc that raises or returns an object other than a String
          # does not match.
          #
          # ## Usage
          #
          # ```ruby
          # expectation = MessageExpectation.new(/must be/)
          # expectation.mismatch_for(message) { |proc_message| proc_message.call(value: nil) }
          # # => nil when the message matches, otherwise the explanation
          # ```
          class MessageExpectation
            # @return [String, Regexp, Object] The expected message or an RSpec matcher
            attr_reader :expected

            # Creates a new message expectation.
            #
            # @param expected [String, Regexp, Object] The expected message or an RSpec matcher
            # @return [MessageExpectation] New expectation instance
            def initialize(expected)
              @expected = expected
            end

            # Describes the expected message for descriptions and failure messages.
            #
            # @return [String] The expected message or the description of the matcher
            def description
              return expected.description if matcher? && expected.respond_to?(:description)

              expected.inspect
            end

            # Checks the message defined for the option.
            #
            # @param message [String, Proc, nil] The message defined for the option
            # @param default_message [String, nil] The message used when the option defines none
            # @yieldparam message [Proc] A Proc message to build
            # @yieldreturn [Object] The built message
            # @return [String, nil] Explanation of the mismatch, or nil if the message matches
            def mismatch_for(message, default_message: nil, &block)
              return matcher_mismatch_for(message) if matcher?

              text_mismatch_for(message.presence || default_message, &block)
            end

            private

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

            # Explains an error raised while building a Proc message.
            #
            # @param error [StandardError] The raised error
            # @return [String] Explanation of the error
            def proc_error_explanation(error)
              <<~MESSAGE
                could not build the Proc message to compare with #{description}:
                  #{error.class}: #{error.message}

                The Proc may receive nil for keywords known only while the service runs, such as `value:`.
              MESSAGE
            end
          end
        end
      end
    end
  end
end
