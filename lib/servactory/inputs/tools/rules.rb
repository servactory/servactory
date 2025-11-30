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
          input = @collection_of_inputs.find(&:with_conflicts?)

          return if input.nil?

          raise_exception_for(input)
        end

        private

        def raise_exception_for(input)
          @context.fail_input!(
            input.name,
            message: exception_message_for(input)
          )
        end

        def exception_message_for(input)
          @context.send(:servactory_service_info).translate(
            "inputs.tools.rules.error",
            input_name: input.name,
            conflict_code: input.conflict_code
          )
        end
      end
    end
  end
end
