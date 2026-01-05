# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Helpers
        # Validates mock input values against service definitions.
        #
        # ## Purpose
        #
        # Ensures that mocked input arguments match the service's input
        # definitions in terms of names. Called automatically when using
        # `.with()` on the fluent builder.
        #
        # ## Usage
        #
        # Called automatically from ServiceMockBuilder:
        #
        # ```ruby
        # allow_service(MyService)
        #   .with(user_id: 123)
        #   .succeeds(result: "ok")
        # ```
        #
        # Can also be called directly:
        #
        # ```ruby
        # InputValidator.validate!(
        #   service_class: MyService,
        #   inputs_matcher: { user_id: 123 }
        # )
        # ```
        #
        # ## Supported Matcher Types
        #
        # - Hash - validates all keys against service inputs
        # - `including(hash)` - validates specified keys only
        # - `any_inputs` - skips validation (accepts anything)
        # - `no_inputs` - validates service has no required inputs
        # - `excluding(hash)` - skips validation (cannot validate exclusion)
        class InputValidator
          include Concerns::ErrorMessages

          # Error raised when validation fails
          class ValidationError < StandardError; end

          class << self
            # Validates inputs and raises on failure.
            #
            # @param service_class [Class] The service class
            # @param inputs_matcher [Hash, Object] Input values or matcher
            # @raise [ValidationError] If validation fails
            # @return [void]
            def validate!(service_class:, inputs_matcher:)
              new(service_class:, inputs_matcher:).validate!
            end
          end

          # Creates a new validator instance.
          #
          # @param service_class [Class] The service class
          # @param inputs_matcher [Hash, Object] Input values or matcher
          # @return [InputValidator] New validator
          def initialize(service_class:, inputs_matcher:)
            @service_class = service_class
            @inputs_matcher = inputs_matcher
          end

          # Runs validation based on matcher type.
          #
          # @raise [ValidationError] If validation fails
          # @return [void]
          def validate!
            keys_to_validate = extract_keys_for_validation

            return if keys_to_validate.nil?

            if keys_to_validate == :no_args
              validate_service_has_no_required_inputs!
            else
              validate_input_names!(keys_to_validate)
            end
          end

          private

          # Extracts keys to validate based on matcher type.
          #
          # @return [Array<Symbol>, Symbol, nil] Keys to validate, :no_args marker, or nil to skip
          def extract_keys_for_validation # rubocop:disable Metrics/MethodLength
            case @inputs_matcher
            when Hash
              @inputs_matcher.keys
            when RSpec::Mocks::ArgumentMatchers::HashIncludingMatcher
              extract_hash_including_keys
            when RSpec::Mocks::ArgumentMatchers::NoArgsMatcher
              :no_args
            when RSpec::Mocks::ArgumentMatchers::AnyArgMatcher,
                 RSpec::Mocks::ArgumentMatchers::HashExcludingMatcher
              nil
            end
          end

          # Extracts keys from HashIncludingMatcher.
          #
          # @return [Array<Symbol>, nil] Keys from the matcher or nil
          def extract_hash_including_keys
            @inputs_matcher.instance_variable_get(:@expected)&.keys
          rescue StandardError
            nil
          end

          # Validates all input names are defined in service.
          #
          # @param provided_keys [Array<Symbol>] Keys to validate
          # @raise [ValidationError] If unknown input names provided
          # @return [void]
          def validate_input_names!(provided_keys)
            defined_inputs = @service_class.info.inputs.keys
            unknown_inputs = provided_keys - defined_inputs

            return if unknown_inputs.empty?

            raise ValidationError, unknown_inputs_message(
              service_class: @service_class,
              unknown_inputs:,
              defined_inputs:
            )
          end

          # Validates service has no required inputs when no_inputs used.
          #
          # @raise [ValidationError] If service has required inputs
          # @return [void]
          def validate_service_has_no_required_inputs!
            required_inputs = @service_class.info.inputs.reject { |_, v| v[:required] == false }.keys

            return if required_inputs.empty?

            raise ValidationError, no_inputs_but_required_message(
              service_class: @service_class,
              required_inputs:
            )
          end
        end
      end
    end
  end
end
