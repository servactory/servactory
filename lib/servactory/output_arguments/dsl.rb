# frozen_string_literal: true

module Servactory
  module OutputArguments
    module DSL
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def inherited(child)
          super

          child.send(:collection_of_output_arguments).merge(collection_of_output_arguments)
        end

        private

        def output(name, **options)
          collection_of_output_arguments << OutputArgument.new(name, **options)
        end

        def collection_of_output_arguments
          @collection_of_output_arguments ||= Collection.new
        end

        def output_arguments_workbench
          @output_arguments_workbench ||= Workbench.work_with(collection_of_output_arguments)
        end
      end
    end
  end
end
