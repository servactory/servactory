# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Helpers
        module Concerns
          module ServiceClassValidation
            include ErrorMessages

            class InvalidServiceClassError < ArgumentError; end

            private

            def validate_service_class!(service_class)
              return if valid_service_class?(service_class)

              raise InvalidServiceClassError, invalid_service_class_message(service_class)
            end

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
