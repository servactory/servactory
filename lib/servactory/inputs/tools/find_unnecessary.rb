# frozen_string_literal: true

module Servactory
  module Inputs
    module Tools
      class FindUnnecessary
        def self.validate!(...)
          new(...).validate!
        end

        def initialize(context, incoming_arguments, collection_of_inputs)
          @context = context
          @incoming_arguments = incoming_arguments
          @collection_of_inputs = collection_of_inputs
        end

        def validate!
          return if unnecessary_attributes.empty?

          message_text = I18n.t(
            "servactory.inputs.tools.find_unnecessary.error",
            service_class_name: @context.class.name,
            unnecessary_attributes: unnecessary_attributes.join(", ")
          )

          raise @context.class.config.input_error_class.new(message: message_text)
        end

        private

        def unnecessary_attributes
          @unnecessary_attributes ||= @incoming_arguments.keys - @collection_of_inputs.names
        end
      end
    end
  end
end
