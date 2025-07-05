# frozen_string_literal: true

module Servactory
  module Outputs
    module DSL
      def self.included(base)
        base.extend(ClassMethods)
        base.include(Workspace)
      end

      module ClassMethods
        def inherited(child)
          super

          child.send(:collection_of_outputs).merge(collection_of_outputs)
        end

        private

        def output(name, *helpers, **options)
          collection_of_outputs << Output.new(
            name,
            *helpers,
            option_helpers: config.output_option_helpers,
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
