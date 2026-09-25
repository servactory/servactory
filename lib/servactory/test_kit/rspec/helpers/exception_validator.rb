# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Helpers
        # Validates the exception of a mock configuration.
        #
        # ## Purpose
        #
        # Ensures that failure mocks have an exception and that the exception
        # type matches the service configuration. Called automatically by
        # MockExecutor for every config before stubbing.
        #
        # ## Usage
        #
        # ```ruby
        # ExceptionValidator.validate!(config)
        # ```
        #
        # ## Validation Strategy
        #
        # - `.call` - accepts any Servactory::Exceptions::Failure subclass
        # - `.call!` - requires the service's configured failure_class or its subclass
        class ExceptionValidator
          include Concerns::ErrorMessages

          class << self
            # Validates a config and raises on failure.
            #
            # @param config [ServiceMockConfig] The config to validate
            # @return [void]
            # @raise [ArgumentError] If config is invalid
            def validate!(config)
              new(config).validate!
            end
          end

          # Creates a new validator instance.
          #
          # @param config [ServiceMockConfig] The config to validate
          # @return [ExceptionValidator] New validator
          def initialize(config)
            @config = config
          end

          # Validates a single configuration.
          #
          # @return [void]
          # @raise [ArgumentError] If config is invalid
          def validate!
            validate_failure_has_exception!
            validate_exception_type!
          end

          private

          # Validates that failure configs have an exception.
          #
          # @return [void]
          # @raise [ArgumentError] If failure config is missing exception
          def validate_failure_has_exception!
            return unless @config.failure? && @config.exception.nil?

            raise ArgumentError, missing_exception_for_failure_message(@config.service_class)
          end

          # Validates that exception is the correct type for the service.
          #
          # @return [void]
          # @raise [ArgumentError] If exception type is wrong
          def validate_exception_type!
            return if @config.exception.nil?
            return if valid_exception_type?

            raise ArgumentError, invalid_exception_type_message(
              service_class: @config.service_class,
              expected_class: failure_class,
              actual_class: @config.exception.class
            )
          end

          # Checks if exception is the correct type.
          #
          # Uses different validation strategies based on method type:
          # - For `.call` (non-bang): Relaxed validation - accepts any Servactory::Exceptions::Failure subclass
          #   because the exception is wrapped in Result and never raised, so type doesn't matter.
          # - For `.call!` (bang): Strict validation - requires the service's configured failure_class
          #   because the exception IS raised and type matters for rescue clauses.
          #
          # @return [Boolean] True if exception is valid type
          def valid_exception_type?
            if @config.bang_method?
              # Strict validation for call! - exception will be raised
              @config.exception.is_a?(failure_class)
            else
              # Relaxed validation for call - exception is only wrapped in Result
              @config.exception.is_a?(Servactory::Exceptions::Failure)
            end
          end

          # Returns the expected failure class for the service.
          #
          # @return [Class] The service's failure class
          def failure_class
            @config.service_class.config.failure_class
          end
        end
      end
    end
  end
end
