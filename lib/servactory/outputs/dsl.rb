# frozen_string_literal: true

module Servactory
  module Outputs
    module DSL
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def inherited(child)
          super

          child.send(:collection_of_outputs).merge(collection_of_outputs)
        end

        private

        def output(name, type:, **options)
          collection_of_outputs << Output.new(name, type, **options)
        end

        def collection_of_outputs
          @collection_of_outputs ||= Collection.new
        end

        def outputs_workbench
          @outputs_workbench ||= Workbench.work_with(collection_of_outputs)
        end
      end
    end
  end
end
