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
            # ```
            #
            # ## Validation
            #
            # Checks the `:required` option in attribute data where `is: true`.
            # If a custom message is provided, also validates the message matches.
            #
            # A Proc message is called with the keyword arguments the library
            # passes to it: `service:`, `input:` and `value:`, which is `nil`.
            # A Proc message that raises or does not return a String does not
            # match, and the failure message shows the error or the returned value.
            class RequiredSubmatcher < Base::Submatcher
              # Creates a new required submatcher.
              #
              # @param context [Base::SubmatcherContext] The submatcher context
              # @param custom_message [String, nil] Optional expected error message
              # @return [RequiredSubmatcher] New submatcher instance
              def initialize(context, custom_message = nil)
                super(context)
                @custom_message = custom_message
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
                return true unless custom_message.present?

                message_equal?
              end

              # Builds the failure message for required validation.
              #
              # @return [String] Failure message with expected vs actual
              def build_failure_message
                return not_required_failure_message unless required?
                return message_error_failure_message unless @message_error.nil?

                <<~MESSAGE
                  should be required with the expected message

                    expected #{custom_message.inspect}
                         got #{@actual_message.inspect}
                MESSAGE
              end

              private

              attr_reader :custom_message

              # Checks if the input has `required: true`.
              #
              # @return [Boolean] True if input is required
              def required?
                attribute_data.fetch(:required).fetch(:is) == true
              end

              # Compares the message of the required option with the expected message.
              #
              # A Proc message raising an error does not match. The error is kept
              # for the failure message.
              #
              # @return [Boolean] True if the message is a String matching the expected message
              def message_equal?
                @actual_message = actual_message
              rescue StandardError => e
                @message_error = e
                false
              else
                @actual_message.is_a?(String) && @actual_message.casecmp(custom_message).zero?
              end

              # Builds the message the library uses for a missing required value.
              #
              # Uses the custom message from `required: { message: }` if provided,
              # otherwise the default message. A Proc message is called with the
              # keyword arguments the library passes to it.
              #
              # @return [Object] The message, a String unless a Proc message returns another object
              def actual_message
                message = attribute_data.fetch(:required).fetch(:message)

                return default_required_message if message.blank?
                return message unless message.is_a?(Proc)

                message.call(
                  service: described_class.send(:new).send(:servactory_service_info),
                  input: attribute_data.fetch(:actor),
                  value: nil
                )
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

              # Builds the failure message for a Proc message that raised an error.
              #
              # @return [String] Failure message with the expected message and the error
              def message_error_failure_message
                <<~MESSAGE
                  should be required with the expected message

                    could not build the Proc message to compare with #{custom_message.inspect}:
                      #{@message_error.class}: #{@message_error.message}

                    The Proc receives nil for `value:`, which is known only while the service runs.
                MESSAGE
              end

              # Generates the default I18n message for required validation.
              #
              # @return [String] Localized default required message
              def default_required_message
                I18n.t(
                  "#{i18n_root_key}.inputs.validations.required.default_error.default",
                  service_class_name: described_class.name,
                  input_name: attribute_name
                )
              end
            end
          end
        end
      end
    end
  end
end
