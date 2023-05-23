# frozen_string_literal: true

module Servactory
  module InputAttributes
    module Tools
      class FindUnnecessary
        def self.check!(...)
          new(...).check!
        end

        def initialize(context, incoming_attributes, collection_of_input_attributes)
          @context = context
          @incoming_attributes = incoming_attributes
          @collection_of_input_attributes = collection_of_input_attributes
        end

        def check!
          return if unnecessary_attributes.empty?

          message_text = I18n.t(
            "servactory.input_attributes.tools.find_unnecessary.error",
            service_class_name: @context.class.name,
            unnecessary_attributes: unnecessary_attributes.join(", ")
          )

          raise Servactory.configuration.input_attribute_error_class.new(message: message_text)
        end

        private

        def unnecessary_attributes
          @unnecessary_attributes ||= @incoming_attributes.keys - @collection_of_input_attributes.names
        end
      end
    end
  end
end
