# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Matchers
        module Submatchers
          module Input
            # Submatcher for validating that an input is optional.
            #
            # ## Purpose
            #
            # Validates that a service input has `required: false` option set,
            # meaning the input can be omitted when calling the service.
            #
            # ## Usage
            #
            # ```ruby
            # it { is_expected.to have_service_input(:nickname).optional }
            # it { is_expected.to have_service_input(:description).optional }
            # ```
            #
            # ## Note
            #
            # Mutually exclusive with `required` submatcher - only one can be used
            # per matcher chain.
            class OptionalSubmatcher < Base::Submatcher
              # Returns description for RSpec output.
              #
              # @return [String] Human-readable description
              def description
                "required: false"
              end

              protected

              # Checks if the input is optional (required: false).
              #
              # @return [Boolean] True if input is not required
              def passes?
                input_required = attribute_data.fetch(:required).fetch(:is)
                input_required == false
              end

              # Builds the failure message for optional validation.
              #
              # @return [String] Failure message with expected vs actual
              def build_failure_message
                <<~MESSAGE
                  should be optional

                    expected required: false
                         got required: true
                MESSAGE
              end
            end
          end
        end
      end
    end
  end
end
