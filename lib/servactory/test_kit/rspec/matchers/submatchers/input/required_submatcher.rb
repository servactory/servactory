# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Matchers
        module Submatchers
          module Input
            # Submatcher for validating that an input is required.
            #
            # ## Purpose
            #
            # Validates that a service input has `required: true` option set.
            # Optionally validates a custom error message for the required validation.
            #
            # ## Usage
            #
            # ```ruby
            # it { is_expected.to have_service_input(:user_id).required }
            # it { is_expected.to have_service_input(:name).required("Name is mandatory") }
            # it { is_expected.to have_service_input(:name).required(/is mandatory/) }
            # it { is_expected.to have_service_input(:name).required(:default) }
            # ```
            #
            # ## Validation
            #
            # Checks the `:required` option in attribute data where `is: true`.
            # If a custom message is provided, also validates the message matches.
            #
            # The expected message follows the rules of `.message`: a String is
            # compared with the message exactly, a Regexp is matched against it,
            # an RSpec matcher is applied to the message as defined, and
            # `:default` checks that the input defines no custom message.
            # The default required message does not depend on the given value,
            # so a String or Regexp is compared with it when there is no
            # custom message.
            #
            # A Proc message is called with the keyword arguments the library
            # passes to it: `service:`, `input:` and `value:`, which is `nil`.
            # A Proc message that raises or does not return a String does not
            # match, and the failure message shows the error or the returned value.
            class RequiredSubmatcher < Base::Submatcher
              include Concerns::RequiredMessage

              # Creates a new required submatcher.
              #
              # @param context [Base::SubmatcherContext] The submatcher context
              # @param custom_message [String, Regexp, Symbol, Object, nil] Optional expected error message,
              #   `:default` or an RSpec matcher
              # @return [RequiredSubmatcher] New submatcher instance
              # @raise [ArgumentError] If the expected message is of another kind
              def initialize(context, custom_message = nil)
                super(context)
                @expectation = Base::MessageExpectation.new(custom_message) unless custom_message.nil?
              end

              # Returns description for RSpec output.
              #
              # @return [String] Human-readable description
              def description
                "required: true"
              end

              protected

              # Checks if the input is required and message matches if specified.
              #
              # @return [Boolean] True if input is required with matching message
              def passes?
                return false unless required?
                return true if expectation.nil?

                @message_mismatch = find_message_mismatch
                @message_mismatch.nil?
              end

              # Builds the failure message for required validation.
              #
              # @return [String] Failure message with expected vs actual
              def build_failure_message
                return not_required_failure_message unless required?

                "should be required with the expected message\n\n#{@message_mismatch.indent(2)}"
              end

              private

              attr_reader :expectation

              # Checks if the input has `required: true`.
              #
              # @return [Boolean] True if input is required
              def required?
                attribute_data.fetch(:required).fetch(:is) == true
              end

              # Compares the message of the required option with the expected message.
              #
              # Uses the custom message from `required: { message: }` if provided,
              # otherwise the default message. A Proc message is called with the
              # keyword arguments the library passes to it.
              #
              # @return [String, nil] Explanation of the mismatch, or nil if the messages match
              def find_message_mismatch
                expectation.mismatch_for(
                  required_custom_message,
                  default_message: default_required_message
                ) { |message| call_required_message(message) }
              end

              # Builds the failure message for an optional input.
              #
              # @return [String] Failure message with expected vs actual required state
              def not_required_failure_message
                <<~MESSAGE
                  should be required

                    expected required: true
                         got required: false
                MESSAGE
              end
            end
          end
        end
      end
    end
  end
end
