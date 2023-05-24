# frozen_string_literal: true

module Servactory
  module Inputs
    module Tools
      class Rules
        def self.check!(...)
          new(...).check!
        end

        def initialize(context, collection_of_inputs)
          @context = context
          @collection_of_inputs = collection_of_inputs
        end

        def check!
          @collection_of_inputs.each do |input_attribute|
            check_for!(input_attribute)
          end
        end

        private

        def check_for!(input_attribute)
          return unless input_attribute.with_conflicts?

          raise_error_for(input_attribute)
        end

        def raise_error_for(input_attribute)
          message_text = I18n.t(
            "servactory.inputs.tools.rules.error",
            service_class_name: @context.class.name,
            input_name: input_attribute.name,
            conflict_code: input_attribute.conflict_code
          )

          raise Servactory.configuration.input_attribute_error_class.new(
            message: message_text,
            input_name: input_attribute.name
          )
        end
      end
    end
  end
end
