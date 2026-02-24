# frozen_string_literal: true

module Servactory
  module Configuration
    module OptionHelpers
      class OptionHelpersCollection
        extend Forwardable

        def_delegators :@collection, :<<, :filter, :map, :find, :merge

        def initialize(collection = Set.new)
          @collection = collection
        end

        def initialize_dup(original)
          super
          @collection = original.instance_variable_get(:@collection).dup
        end

        def dynamic_options
          OptionHelpersCollection.new(filter(&:dynamic_option?))
        end

        def find_by(name:)
          find { |helper| helper.name == name }
        end

        def replace(name:, with:)
          # TODO: Add index-based lookup in version 3.1.
          old = find { |helper| helper.name == name }
          return unless old

          @collection.delete(old)
          @collection.add(with)
        end
      end
    end
  end
end
