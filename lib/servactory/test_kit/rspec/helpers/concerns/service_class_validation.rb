# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Helpers
        module Concerns
          # Concern providing validation for Servactory service classes.
          #
          # ## Purpose
          #
          # ServiceClassValidation ensures that values passed to service mock helpers
          # are valid Servactory service classes. It checks for the required interface
          # methods and provides helpful error messages when validation fails.
          #
          # ## Usage
          #
          # Include in helper classes that accept service classes:
          #
          # ```ruby
          # class ServiceMockBuilder
          #   include Concerns::ServiceClassValidation
          #
          #   def initialize(service_class)
          #     validate_service_class!(service_class)
          #     @service_class = service_class
          #   end
          # end
          # ```
          #
          # ## Validation Rules
          #
          # A valid service class must:
          # - Be a Class (not instance or module)
          # - Respond to `.call` method
          # - Respond to `.call!` method
          # - Respond to `.info` method (for introspection)
          module ServiceClassValidation
            include ErrorMessages

            # Error raised when an invalid service class is provided.
            class InvalidServiceClassError < ArgumentError; end

            private

            # Validates that the given value is a valid Servactory service class.
            #
            # @param service_class [Object] The value to validate
            # @return [void]
            # @raise [InvalidServiceClassError] If validation fails
            def validate_service_class!(service_class)
              return if valid_service_class?(service_class)

              raise InvalidServiceClassError, invalid_service_class_message(service_class)
            end

            # Checks if the given value is a valid Servactory service class.
            #
            # @param service_class [Object] The value to check
            # @return [Boolean] True if valid Servactory service class
            def valid_service_class?(service_class)
              return false unless service_class.is_a?(Class)
              return false unless service_class.respond_to?(:call)
              return false unless service_class.respond_to?(:call!)
              return false unless service_class.respond_to?(:info)

              true
            end
          end
        end
      end
    end
  end
end
