# frozen_string_literal: true

module Servactory
  module Outputs
    module Tools
      class Conflicts
        def self.check!(...)
          new(...).check!
        end

        def initialize(context, collection_of_outputs, collection_of_internals)
          @context = context
          @collection_of_outputs = collection_of_outputs
          @collection_of_internals = collection_of_internals
        end

        def check!
          return if overlapping_attributes.empty?

          message_text = I18n.t(
            "servactory.outputs.tools.conflicts.error",
            service_class_name: @context.class.name,
            overlapping_attributes: overlapping_attributes.join(", ")
          )

          raise Servactory.configuration.output_attribute_error_class.new(message: message_text)
        end

        private

        def overlapping_attributes
          @overlapping_attributes ||=
            @collection_of_outputs.names.intersection(@collection_of_internals.names)
        end
      end
    end
  end
end
