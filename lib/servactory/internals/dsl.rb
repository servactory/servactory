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
          collection_of_internals << Internal.new(
            name,
            *helpers,
            hash_mode_class_names: config.hash_mode_class_names,
            option_helpers: config.internal_option_helpers,
            **options
          )
        end

        def collection_of_internals
          @collection_of_internals ||= Collection.new
        end
      end
    end
  end
end
