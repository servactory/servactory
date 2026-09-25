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

        def internal(name, *helpers, **options)
          internal = Internal.new(
            name,
            *helpers,
            option_helpers: config.internal_option_helpers,
            **options
          )

          if internal.types.empty?
            raise ArgumentError, "[#{self.name}] Internal attribute `#{name}` must have the `type` option"
          end

          collection_of_internals << internal
        end

        def collection_of_internals
          @collection_of_internals ||= Collection.new
        end
      end
    end
  end
end
