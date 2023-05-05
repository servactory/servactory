# frozen_string_literal: true

module ServiceFactory
  module InternalArguments
    module DSL
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        private

        def internal(name, **options)
          collection_of_internal_arguments << InternalArgument.new(name, **options)
        end

        def collection_of_internal_arguments
          @collection_of_internal_arguments ||= Collection.new
        end

        def internal_arguments_workbench
          @internal_arguments_workbench ||= Workbench.work_with(collection_of_internal_arguments)
        end
      end
    end
  end
end
