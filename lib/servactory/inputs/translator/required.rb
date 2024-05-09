# frozen_string_literal: true

module Servactory
  module Inputs
    module Translator
      module Required
        module_function

        def default_message
          lambda do |service:, input:, value:|
            i18n_key = "servactory.inputs.validations.required.default_error."
            i18n_key += input.collection_mode? && value.present? ? "for_collection" : "default"

            I18n.t(
              i18n_key,
              service_class_name: service.class_name,
              input_name: input.name
            )
          end
        end
      end
    end
  end
end
