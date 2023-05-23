# frozen_string_literal: true

module Servactory
  module OutputAttributes
    module Tools
      class Conflicts
        def self.check!(...)
          new(...).check!
        end

        def initialize(context, collection_of_output_attributes, collection_of_internal_attributes)
          @context = context
          @collection_of_output_attributes = collection_of_output_attributes
          @collection_of_internal_attributes = collection_of_internal_attributes
        end

        def check!
          return if overlapping_attributes.empty?

          message_text = I18n.t(
            "servactory.output_attributes.tools.conflicts.error",
            service_class_name: @context.class.name,
            overlapping_attributes: overlapping_attributes.join(", ")
          )

          raise Servactory.configuration.output_attribute_error_class.new(message: message_text)
        end

        private

        def overlapping_attributes
          @overlapping_attributes ||=
            @collection_of_output_attributes.names.intersection(@collection_of_internal_attributes.names)
        end
      end
    end
  end
end
