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

          raise_exception_for(input)
        end

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
