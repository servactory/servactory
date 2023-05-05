# frozen_string_literal: true

module Servactory
  module InputArguments
    module DSL
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        private

        def input(name, **options)
          collection_of_input_arguments << InputArgument.new(name, **options)
        end

        def collection_of_input_arguments
          @collection_of_input_arguments ||= Collection.new
        end

        def input_arguments_workbench
          @input_arguments_workbench ||= Workbench.work_with(collection_of_input_arguments)
        end
      end
    end
  end
end
