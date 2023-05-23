# frozen_string_literal: true

module Servactory
  module InputAttributes
    module DSL
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def inherited(child)
          super

          child.send(:collection_of_input_attributes).merge(collection_of_input_attributes)
        end

        private

        def input(name, **options)
          collection_of_input_attributes << InputAttribute.new(
            name,
            **options
          )
        end

        def collection_of_input_attributes
          @collection_of_input_attributes ||= Collection.new
        end

        def input_attributes_workbench
          @input_attributes_workbench ||= Workbench.work_with(collection_of_input_attributes)
        end
      end
    end
  end
end
