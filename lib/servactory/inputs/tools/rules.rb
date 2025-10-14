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
          message_text = @context.send(:servactory_service_info).translate(
            "inputs.tools.rules.error",
            input_name: input.name,
            conflict_code: input.conflict_code
          )

          @context.fail_input!(input.name, message: message_text)
        end
      end
    end
  end
end
