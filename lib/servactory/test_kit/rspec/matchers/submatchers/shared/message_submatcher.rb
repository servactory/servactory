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
            # ```
            #
            # ## Note
            #
            # Requires `requires_last_submatcher: true` - must follow another
            # submatcher. Uses the previous submatcher's OPTION_NAME constant
            # to find the message field.
            #
            # A Proc message is called with the keyword arguments the library
            # passes to it. Values known only while the service runs, such as
            # `value:`, are `nil`.
            class MessageSubmatcher < Base::Submatcher
              # Option name in attribute data (unused - uses last submatcher's)
              OPTION_NAME = :message
              # Key for the message within the option
              OPTION_BODY_KEY = :message

              # Creates a new message submatcher.
              #
              # @param context [Base::SubmatcherContext] The submatcher context
              # @param custom_message [String] Expected error message
              # @return [MessageSubmatcher] New submatcher instance
              def initialize(context, custom_message)
                super(context)
                @custom_message = custom_message
              end

              # Returns description for RSpec output.
              #
              # @return [String] Human-readable description with message
              def description
                "message: #{@attribute_schema_message}"
              end

              protected

              # Checks if the option's message matches expected message.
              #
              # @return [Boolean] True if messages match
              def passes?
                last_submatcher = context.last_submatcher
                attribute_schema = attribute_data.fetch(last_submatcher.class::OPTION_NAME)
                @attribute_schema_is = attribute_schema.fetch(last_submatcher.class::OPTION_BODY_KEY)
                @attribute_schema_message = attribute_schema.fetch(:message)

                schema_message_equal?
              end

              # Builds the failure message for message validation.
              #
              # @return [String] Failure message with expected vs actual message
              def build_failure_message
                return "" if schema_message_equal?

                <<~MESSAGE
                  should return expected message in case of problem:

                    expected #{@attribute_schema_message.inspect}
                         got #{custom_message.inspect}
                MESSAGE
              end

              private

              attr_reader :custom_message

              # Compares expected and actual messages with type-aware logic.
              #
              # Handles RSpec matchers, Procs, and plain strings.
              #
              # @return [Boolean] True if messages match
              def schema_message_equal? # rubocop:disable Metrics/AbcSize, Metrics/MethodLength, Metrics/PerceivedComplexity
                @schema_message_equal ||= begin
                  if custom_message.present? && !@attribute_schema_message.nil?
                    if custom_message.is_a?(RSpec::Matchers::BuiltIn::BaseMatcher)
                      RSpec::Expectations::ValueExpectationTarget
                        .new(@attribute_schema_message)
                        .to(custom_message)
                      true
                    elsif @attribute_schema_message.is_a?(Proc)
                      call_message(@attribute_schema_message).casecmp(custom_message).zero?
                    else
                      @attribute_schema_message.casecmp(custom_message).zero?
                    end
                  else
                    true
                  end
                rescue RSpec::Expectations::ExpectationNotMetError
                  false
                end
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
                option_name = context.last_submatcher.class::OPTION_NAME
                return { expected_type: @attribute_schema_is.join(", ") } if option_name == :type

                { option_name:, option_value: @attribute_schema_is }
              end
            end
          end
        end
      end
    end
  end
end
