# frozen_string_literal: true

module Servactory
  module InputArguments
    module DSL
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def inherited(child)
          super

          child.send(:collection_of_input_arguments).merge(collection_of_input_arguments)
        end

        private

        def input(name, **options)
          collection_of_input_arguments << InputArgument.new(
            name,
            collection_of_options: collection_of_input_options,
            **options
          )
        end

        def collection_of_input_arguments
          @collection_of_input_arguments ||= Collection.new
        end

        def collection_of_input_options
          @collection_of_input_options ||= OptionsCollection.new
        end

        def input_arguments_workbench
          @input_arguments_workbench ||= Workbench.work_with(collection_of_input_arguments)
        end
      end
    end
  end
end
