# frozen_string_literal: true

module Servactory
  module Inputs
    module Tools
      class Unnecessary
        def self.find!(...)
          new(...).find!
        end

        def initialize(context, collection_of_inputs)
          @context = context
          @collection_of_inputs = collection_of_inputs
        end

        def find!
          return if unnecessary_attributes.empty?

          message_text = @context.send(:servactory_service_info).translate(
            "inputs.tools.find_unnecessary.error",
            unnecessary_attributes: unnecessary_attributes.join(", ")
          )

          raise @context.class.config.input_exception_class.new(
            context: @context,
            message: message_text
          )
        end

        private

        def unnecessary_attributes
          @unnecessary_attributes ||=
            @context.send(:servactory_service_warehouse).inputs.names -
            @collection_of_inputs.names
        end
      end
    end
  end
end
