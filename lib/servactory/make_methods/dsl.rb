# frozen_string_literal: true

module Servactory
  module MakeMethods
    module DSL
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def inherited(child)
          super

          child.send(:collection_of_make_methods).merge(collection_of_make_methods)
        end

        private

        def make(name, **options)
          collection_of_make_methods << MakeMethod.new(name, **options)
        end

        def collection_of_make_methods
          @collection_of_make_methods ||= Collection.new
        end

        def make_methods_workbench
          @make_methods_workbench ||= Workbench.work_with(collection_of_make_methods)
        end
      end
    end
  end
end
