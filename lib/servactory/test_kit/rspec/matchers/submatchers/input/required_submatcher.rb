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
                required_data = attribute_data.fetch(:required)
                is_required = required_data.fetch(:is)

                return false unless is_required == true
                return true unless custom_message.present?

                actual_message = required_data.fetch(:message) || default_required_message
                actual_message.casecmp(custom_message).zero?
              end

              # Builds the failure message for required validation.
              #
              # @return [String] Failure message with expected vs actual
              def build_failure_message
                <<~MESSAGE
                  should be required

                    expected required: true
                         got required: false
                MESSAGE
              end

              private

              attr_reader :custom_message

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
