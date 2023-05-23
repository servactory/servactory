# frozen_string_literal: true

module Servactory
  module InternalAttributes
    module DSL
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def inherited(child)
          super

          child.send(:collection_of_internal_attributes).merge(collection_of_internal_attributes)
        end

        private

        def internal(name, **options)
          collection_of_internal_attributes << InternalAttribute.new(name, **options)
        end

        def collection_of_internal_attributes
          @collection_of_internal_attributes ||= Collection.new
        end

        def internal_attributes_workbench
          @internal_attributes_workbench ||= Workbench.work_with(collection_of_internal_attributes)
        end
      end
    end
  end
end
