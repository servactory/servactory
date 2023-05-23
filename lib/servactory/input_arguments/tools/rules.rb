# frozen_string_literal: true

module Servactory
  module InputArguments
    module Tools
      class Rules
        def self.check!(...)
          new(...).check!
        end

        def initialize(context, collection_of_input_arguments)
          @context = context
          @collection_of_input_arguments = collection_of_input_arguments
        end

        def check!
          @collection_of_input_arguments.each do |input_argument|
            check_for!(input_argument)
          end
        end

        private

        def check_for!(input_argument)
          return unless input_argument.with_conflicts?

          raise_error_for(input_argument)
        end

        def raise_error_for(input_argument)
          message_text = I18n.t(
            "servactory.input_arguments.tools.rules.error",
            service_class_name: @context.class.name,
            input_name: input_argument.name,
            conflict_code: input_argument.conflict_code
          )

          raise Servactory.configuration.input_argument_error_class.new(
            message: message_text,
            input_name: input_argument.name
          )
        end
      end
    end
  end
end
