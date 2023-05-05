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

          raise Servactory.configuration.output_argument_error_class,
                "The \"#{@context.class.name}\" service contains internal attributes that " \
                "conflict with outputs: \"#{overlapping_attributes.join(', ')}\""
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
