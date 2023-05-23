# frozen_string_literal: true

module Servactory
  module OutputArguments
    module Tools
      class Conflicts
        def self.check!(...)
          new(...).check!
        end

        def initialize(context, collection_of_output_arguments, collection_of_internal_arguments)
          @context = context
          @collection_of_output_arguments = collection_of_output_arguments
          @collection_of_internal_arguments = collection_of_internal_arguments
        end

        def check!
          return if overlapping_attributes.empty?

          message_text = I18n.t(
            "servactory.output_arguments.tools.conflicts.error",
            service_class_name: @context.class.name,
            overlapping_attributes: overlapping_attributes.join(", ")
          )

          raise Servactory.configuration.output_argument_error_class.new(message: message_text)
        end

        private

        def overlapping_attributes
          @overlapping_attributes ||=
            @collection_of_output_arguments.names.intersection(@collection_of_internal_arguments.names)
        end
      end
    end
  end
end
