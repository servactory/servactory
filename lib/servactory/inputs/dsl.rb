# frozen_string_literal: true

module Servactory
  module Inputs
    module DSL
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def inherited(child)
          super

          child.send(:collection_of_inputs).merge(collection_of_inputs)
        end

        private

        def input(name, **options)
          collection_of_inputs << Input.new(
            name,
            **options
          )
        end

        def collection_of_inputs
          @collection_of_inputs ||= Collection.new
        end

        def inputs_workbench
          @inputs_workbench ||= Workbench.work_with(collection_of_inputs)
        end
      end
    end
  end
end
