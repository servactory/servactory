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
          collection_of_inputs << Input.new(
            name,
            *helpers,
            config: config,
            **options
          )
        end

        def collection_of_inputs
          @collection_of_inputs ||= Collection.new
        end
      end
    end
  end
end
