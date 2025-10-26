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

          @context.fail_input!(
            nil,
            message: exception_message
          )
        end

        private

        def exception_message
          @context.send(:servactory_service_info).translate(
            "inputs.tools.find_unnecessary.error",
            unnecessary_attributes: unnecessary_attributes.join(", ")
          )
        end

        ########################################################################

        def unnecessary_attributes
          @unnecessary_attributes ||=
            @context.send(:servactory_service_warehouse).inputs.names -
            @collection_of_inputs.names
        end
      end
    end
  end
end
