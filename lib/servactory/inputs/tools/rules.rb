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
          @collection_of_inputs.each do |input|
            check_for!(input)
          end
        end

        private

        def check_for!(input)
          return unless input.with_conflicts?

          raise_error_for(input)
        end

        def raise_error_for(input)
          message_text = I18n.t(
            "servactory.inputs.tools.rules.error",
            service_class_name: @context.class.name,
            input_name: input.name,
            conflict_code: input.conflict_code
          )

          raise Servactory.configuration.input_error_class.new(
            message: message_text,
            input_name: input.name
          )
        end
      end
    end
  end
end
