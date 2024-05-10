# frozen_string_literal: true

module Servactory
  module Inputs
    module Translator
      module Required
        module_function

        def default_message
          lambda do |service:, input:, **|
            service.translate(
              "inputs.validations.required.default_error.default",
              input_name: input.name
            )
          end
        end
      end
    end
  end
end
