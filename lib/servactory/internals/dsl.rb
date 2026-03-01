# frozen_string_literal: true

module Servactory
  module Internals
    module DSL
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def inherited(child)
          super

          child.send(:collection_of_internals).merge(collection_of_internals)
        end

        private

        # DEPRECATED: This method will be removed in a future release.
        def internal(name, *helpers, **options)
          collection_of_internals << Internal.new(
            name,
            *helpers,
            option_helpers: config.internal_option_helpers,
            **options
          )
        end

        def internals(&block)
          @internals_factory ||= Factory.new(config, collection_of_internals)

          @internals_factory.instance_eval(&block)
        end

        def collection_of_internals
          @collection_of_internals ||= Collection.new
        end
      end
    end
  end
end
