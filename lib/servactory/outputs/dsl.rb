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

        # DEPRECATED: This method will be removed in a future release.
        def output(name, *helpers, **options)
          collection_of_outputs << Output.new(
            name,
            *helpers,
            option_helpers: config.output_option_helpers,
            **options
          )
        end

        def outputs(&block)
          @outputs_factory ||= Factory.new(config, collection_of_outputs)

          @outputs_factory.instance_eval(&block)
        end

        def collection_of_outputs
          @collection_of_outputs ||= Collection.new
        end
      end
    end
  end
end
