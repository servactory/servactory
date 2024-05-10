# frozen_string_literal: true

module Servactory
  module Inputs
    module Translator
      module Required
        module_function

        def default_message
          lambda do |service:, input:, value:|
            i18n_key = "inputs.validations.required.default_error."
            i18n_key += input.collection_mode? && value.present? ? "for_collection" : "default"

            service.translate(
              i18n_key,
              input_name: input.name
            )
          end
        end
      end
    end
  end
end
