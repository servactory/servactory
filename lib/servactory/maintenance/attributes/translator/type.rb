# frozen_string_literal: true

module Servactory
  module Maintenance
    module Attributes
      module Translator
        module Type
          extend self

          def default_message
            lambda do |service_class_name:, attribute:, _value:, key_name:, expected_type:, given_type:|
              if attribute.hash_mode? && key_name.present?
                for_hash_mode_with(service_class_name: service_class_name, attribute: attribute, key_name: key_name,
                                   expected_type: expected_type, given_type: given_type)
              else
                for_others_with(service_class_name: service_class_name, attribute: attribute,
                                expected_type: expected_type, given_type: given_type)
              end
            end
          end

          private

          def for_hash_mode_with(service_class_name:, attribute:, key_name:, expected_type:, given_type:) # rubocop:disable Metrics/MethodLength
            hash_message = attribute.schema.fetch(:message)

            if hash_message.is_a?(Proc)
              hash_message.call(
                **Servactory::Utils.fetch_hash_with_desired_attribute(attribute),
                key_name: key_name,
                expected_type: expected_type,
                given_type: given_type
              )
            elsif hash_message.is_a?(String) && hash_message.present?
              hash_message
            else
              I18n.t(
                "servactory.#{attribute.i18n_name}.validations.type.default_error.for_hash.wrong_element_type",
                service_class_name: service_class_name,
                "#{attribute.system_name}_name": attribute.name,
                key_name: key_name,
                expected_type: expected_type,
                given_type: given_type
              )
            end
          end

          def for_others_with(service_class_name:, attribute:, expected_type:, given_type:)
            I18n.t(
              "servactory.#{attribute.i18n_name}.validations.type.default_error.default",
              service_class_name: service_class_name,
              "#{attribute.system_name}_name": attribute.name,
              expected_type: expected_type,
              given_type: given_type
            )
          end
        end
      end
    end
  end
end
