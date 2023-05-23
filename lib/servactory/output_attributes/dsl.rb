# frozen_string_literal: true

module Servactory
  module OutputAttributes
    module DSL
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def inherited(child)
          super

          child.send(:collection_of_output_attributes).merge(collection_of_output_attributes)
        end

        private

        def output(name, **options)
          collection_of_output_attributes << OutputAttribute.new(name, **options)
        end

        def collection_of_output_attributes
          @collection_of_output_attributes ||= Collection.new
        end

        def output_attributes_workbench
          @output_attributes_workbench ||= Workbench.work_with(collection_of_output_attributes)
        end
      end
    end
  end
end
