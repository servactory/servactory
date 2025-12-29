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
            # it { is_expected.to have_service_input(:email).inclusion(%w[a b]).message("Invalid email") }
            # it { is_expected.to have_service_input(:data).schema({ key: String }).message("Invalid schema") }
            # ```
            #
            # ## Note
            #
            # Requires `requires_last_submatcher: true` - must follow another
            # submatcher. Uses the previous submatcher's OPTION_NAME constant
            # to find the message field.
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
                      @attribute_schema_message.call.casecmp(custom_message).zero?
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
            end
          end
        end
      end
    end
  end
end
