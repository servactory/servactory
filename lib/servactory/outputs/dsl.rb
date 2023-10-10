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

        def output(name, **options)
          collection_of_outputs << Output.new(
            name,
            collection_mode_class_names: config.collection_mode_class_names,
            **options
          )
        end

        def collection_of_outputs
          @collection_of_outputs ||= Collection.new
        end
      end
    end
  end
end
