# frozen_string_literal: true

module Servactory
  module InputArguments
    module Tools
      class FindUnnecessary
        def self.check!(...)
          new(...).check!
        end

        def initialize(context, incoming_arguments, collection_of_input_arguments)
          @context = context
          @incoming_arguments = incoming_arguments
          @collection_of_input_arguments = collection_of_input_arguments
        end

        def check!
          return if unnecessary_attributes.empty?

          raise Servactory.configuration.input_argument_error_class,
                "[#{@context.class.name}] Unexpected attributes: `#{unnecessary_attributes.join(', ')}`"
        end

        private

        def unnecessary_attributes
          @unnecessary_attributes ||= @incoming_arguments.keys - @collection_of_input_arguments.names
        end
      end
    end
  end
end
