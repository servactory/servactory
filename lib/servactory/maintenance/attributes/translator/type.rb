# frozen_string_literal: true

module Servactory
  module Maintenance
    module Attributes
      module Translator
        module Type
          extend self

          def default # rubocop:disable Metrics/MethodLength
            lambda do |service_class_name:, attribute:, value:, key_name:, expected_type:, given_type:|
              if attribute.collection_mode?
                for_collection_mode_with(service_class_name: service_class_name, attribute: attribute, value: value,
                                         expected_type: expected_type, given_type: given_type)
              elsif attribute.hash_mode? && key_name.present?
                for_hash_mode_with(service_class_name: service_class_name, attribute: attribute, key_name: key_name,
                                   expected_type: expected_type, given_type: given_type)
              else
                for_others_with(service_class_name: service_class_name, attribute: attribute,
                                expected_type: expected_type, given_type: given_type)
              end
            end
          end

          private

          def for_collection_mode_with(service_class_name:, attribute:, value:, expected_type:, given_type:) # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
            collection_message = attribute.consists_of.fetch(:message)

            if collection_message.is_a?(Proc)
              collection_message.call(
                "#{attribute.system_name}_name": attribute.name,
                expected_type: expected_type,
                given_type: given_type
              )
            elsif collection_message.is_a?(String) && collection_message.present?
              collection_message
            elsif value.is_a?(attribute.types.fetch(0, Array))
              I18n.t(
                "servactory.#{attribute.i18n_name}.validations.type.default_error.for_collection.wrong_element_type",
                service_class_name: service_class_name,
                "#{attribute.system_name}_name": attribute.name,
                expected_type: expected_type,
                given_type: given_type
              )
            else
              I18n.t(
                "servactory.#{attribute.i18n_name}.validations.type.default_error.for_collection.wrong_type",
                service_class_name: service_class_name,
                "#{attribute.system_name}_name": attribute.name,
                expected_type: attribute.types.fetch(0, Array),
                given_type: value.class.name
              )
            end
          end

          def for_hash_mode_with(service_class_name:, attribute:, key_name:, expected_type:, given_type:) # rubocop:disable Metrics/MethodLength
            hash_message = attribute.schema.fetch(:message)

            if hash_message.is_a?(Proc)
              hash_message.call(
                "#{attribute.system_name}_name": attribute.name,
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
