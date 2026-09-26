# frozen_string_literal: true

module Servactory
  module Inputs
    module DSL
      def self.included(base)
        base.extend(ClassMethods)
        base.include(Workspace)
      end

      module ClassMethods
        def inherited(child)
          super

          child.send(:collection_of_inputs).merge(collection_of_inputs)
        end

        private

        def input(name, *helpers, **options)
          input = Input.new(
            name,
            *helpers,
            option_helpers: config.input_option_helpers,
            **options
          )

          raise ArgumentError, "[#{self.name}] Input `#{name}` must have the `type` option" if input.types.empty?

          collection_of_inputs << input
        end

        def collection_of_inputs
          @collection_of_inputs ||= Collection.new
        end
      end
    end
  end
end
