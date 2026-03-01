# frozen_string_literal: true

module Servactory
  module Inputs
    module DSL
      def self.included(base)
        base.extend(ClassMethods)
        base.include(Workspace)
      end

      module ClassMethods
        def inherited(child)
          super

          child.send(:collection_of_inputs).merge(collection_of_inputs)
        end

        private

        # DEPRECATED: This method will be removed in a future release.
        def input(name, *helpers, **options)
          collection_of_inputs << Input.new(
            name,
            *helpers,
            option_helpers: config.input_option_helpers,
            **options
          )
        end

        def inputs(&block)
          @inputs_factory ||= Factory.new(config, collection_of_inputs)

          @inputs_factory.instance_eval(&block)
        end

        def collection_of_inputs
          @collection_of_inputs ||= Collection.new
        end
      end
    end
  end
end
