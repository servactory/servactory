# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Matchers
        module Submatchers
          module Shared
            # Submatcher for validating custom error messages.
            #
            # ## Purpose
            #
            # Validates that the previous submatcher's option has the expected
            # custom error message. Must be used after another submatcher that
            # defines an option with a message field.
            #
            # ## Usage
            #
            # ```ruby
            # it { is_expected.to have_service_input(:id).type(Integer).message("ID must be an Integer") }
            # it { is_expected.to have_service_input(:email).inclusion(%w[a b]).message("Invalid email") }
            # it { is_expected.to have_service_input(:data).schema({ key: String }).message("Invalid schema") }
            # it { is_expected.to have_service_input(:email).inclusion(%w[a b]).message(/Invalid/) }
            # it { is_expected.to have_service_input(:email).inclusion(%w[a b]).message(be_a(Proc)) }
            # it { is_expected.to have_service_input(:email).inclusion(%w[a b]).message(:default) }
            # it { is_expected.to have_service_input(:age).must(:be_adult).message("Must be an adult") }
            # ```
            #
            # ## Note
            #
            # Requires `requires_last_submatcher: true` - must follow another
            # submatcher. Uses the previous submatcher's OPTION_NAME constant,
            # or its `option_name` for options with a configurable name such as
            # `target`, to find the message field. Chaining it after a submatcher
            # without such an option raises ArgumentError.
            #
            # After `.must`, the must submatcher stores the expected message
            # itself (see MustSubmatcher).
            #
            # Every `.message` in a chain is checked, each against the option
            # chained right before it:
            #
            # ```ruby
            # it do
            #   is_expected.to have_service_input(:status)
            #     .type(Symbol).message("Status must be a Symbol")
            #     .inclusion(%i[active inactive]).message("Status must be active or inactive")
            # end
            # ```
            #
            # A String is compared with the message exactly, a Regexp is matched
            # against it, and an RSpec matcher is applied to the message as
            # defined, for example to check that it is a Proc.
            #
            # A Proc message is called with the keyword arguments the library
            # passes to it before a String or Regexp comparison. Values known
            # only while the service runs, such as `value:`, are `nil`.
            # A Proc message that raises with them or does not return a String
            # does not match, and the failure message shows the error or the
            # returned value.
            #
            # `:default` checks that the option defines no custom message.
            # Without a custom message, a String or Regexp does not match:
            # the default message of these options depends on values known
            # only while the service runs. Check it with `raise_error` instead.
            class MessageSubmatcher < Base::Submatcher
              # Option name in attribute data (unused - uses last submatcher's)
              OPTION_NAME = :message
              # Key for the message within the option
              OPTION_BODY_KEY = :message

              # Creates a new message submatcher.
              #
              # @param context [Base::SubmatcherContext] The submatcher context
              # @param custom_message [String, Regexp, Symbol, Object] Expected error message, `:default`
              #   or an RSpec matcher
              # @return [MessageSubmatcher] New submatcher instance
              # @raise [ArgumentError] If the previous submatcher checks no option with a message,
              #   or the expected message is of another kind
              def initialize(context, custom_message)
                super(context)
                ensure_option_with_message!
                @custom_message = custom_message
                @expectation = Base::MessageExpectation.new(custom_message)
              end

              # Returns description for RSpec output.
              #
              # @return [String] Human-readable description with message
              def description
                "message: #{expectation.description}"
              end

              protected

              # Checks if the option's message matches expected message.
              #
              # @return [Boolean] True if messages match
              def passes?
                attribute_schema = attribute_data[option_name]
                @mismatch = attribute_schema.is_a?(Hash) ? find_mismatch(attribute_schema) : missing_option_explanation

                @mismatch.nil?
              end

              # Builds the failure message for message validation.
              #
              # @return [String] Failure message with expected vs actual message
              def build_failure_message
                "should return expected message in case of problem:\n\n#{@mismatch.indent(2)}"
              end

              private

              attr_reader :custom_message, :expectation

              # Ensures that the previous submatcher checks an option with a message.
              #
              # @return [void]
              # @raise [ArgumentError] If there is no previous submatcher or its option has no message
              def ensure_option_with_message!
                last_submatcher = context.last_submatcher
                return if last_submatcher.respond_to?(:option_name)
                return if last_submatcher.is_a?(Base::Submatcher) && last_submatcher.class.const_defined?(:OPTION_NAME)

                raise ArgumentError, option_with_message_error_message(last_submatcher)
              end

              # Builds the error message for a `message` chained without an option with a message.
              #
              # @param last_submatcher [Base::Submatcher, nil] The previous submatcher
              # @return [String] Error message
              def option_with_message_error_message(last_submatcher)
                position = last_submatcher.nil? ? "first in the chain" : "after `#{last_submatcher.description}`"
                required = last_submatcher.is_a?(Input::RequiredSubmatcher)
                hint = required ? " To check the required message, pass it to `required`." : ""

                "`message` checks the message of the option chained right before it: chain it after " \
                  "`type`, `consists_of`, `schema`, `inclusion`, `target` or `must`, not #{position}.#{hint}"
              end

              # Compares the option's message with the expected message.
              #
              # @param attribute_schema [Hash] The option in attribute data
              # @return [String, nil] Explanation of the mismatch, or nil if the messages match
              def find_mismatch(attribute_schema)
                @attribute_schema_is = attribute_schema[context.last_submatcher.class::OPTION_BODY_KEY]
                @attribute_schema_message = attribute_schema[:message]

                expectation.mismatch_for(@attribute_schema_message) { |message| call_message(message) }
              end

              # Explains a mismatch for an attribute without the option.
              #
              # @return [String] Explanation of the mismatch
              def missing_option_explanation
                <<~MESSAGE
                  expected #{expectation.description}
                       got no `#{option_name}` option
                MESSAGE
              end

              # Calls a Proc message with the keyword arguments it accepts.
              #
              # Required keywords without a known value receive `nil`.
              #
              # @param message [Proc] The attribute's message
              # @return [String] The message built by the Proc
              def call_message(message)
                arguments = message_arguments
                parameters = message.parameters.group_by(&:first).transform_values { |list| list.map(&:last) }

                keywords = parameters.fetch(:keyreq, []).to_h { |name| [name, arguments[name]] }
                keywords.merge!(parameters.key?(:keyrest) ? arguments : arguments.slice(*parameters.fetch(:key, [])))

                message.call(**keywords)
              end

              # Builds the keyword arguments the library passes to Proc messages.
              #
              # @return [Hash{Symbol => Object}] Message arguments
              def message_arguments
                {
                  service: described_class.send(:new).send(:servactory_service_info),
                  attribute_type => attribute_data.fetch(:actor),
                  value: nil,
                  **option_message_arguments
                }
              end

              # Builds the option-specific keyword arguments for Proc messages.
              #
              # The `type` option passes the expected types, other options
              # pass their name and value.
              #
              # @return [Hash{Symbol => Object}] Option message arguments
              def option_message_arguments
                return { expected_type: @attribute_schema_is.join(", ") } if option_name == :type

                { option_name:, option_value: @attribute_schema_is }
              end

              # Returns the name of the option validated by the previous submatcher.
              #
              # @return [Symbol] Option name in attribute data
              def option_name
                last_submatcher = context.last_submatcher
                return last_submatcher.option_name if last_submatcher.respond_to?(:option_name)

                last_submatcher.class::OPTION_NAME
              end
            end
          end
        end
      end
    end
  end
end
