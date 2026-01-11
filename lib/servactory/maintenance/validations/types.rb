# frozen_string_literal: true

module Servactory
  module Maintenance
    module Validations
      class Types
        # Validates value against expected types.
        #
        # Returns nil on success, error data Hash on failure.
        #
        # @param context [Object] Service context for error info
        # @param attribute [Inputs::Input, Internals::Internal, Outputs::Output] Attribute being validated
        # @param types [Array<Class, String, Symbol>] Expected type classes
        # @param value [Object] Value to validate
        # @return [Hash, nil] nil on success, error data Hash on failure
        def self.validate(context:, attribute:, types:, value:) # rubocop:disable Metrics/MethodLength
          prepared_types = types.map { |type| Servactory::Utils.constantize_class(type) }

          return if prepared_types.any? { |type| value.is_a?(type) }

          {
            message: Servactory::Maintenance::Attributes::Translator::Type.default_message,
            service: context.send(:servactory_service_info),
            attribute:,
            value:,
            key_name: nil,
            expected_type: prepared_types.join(", "),
            given_type: value.class.name
          }
        end
      end
    end
  end
end
