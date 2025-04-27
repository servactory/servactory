# frozen_string_literal: true

module Servactory
  module OldConfiguration
    module OptionHelpers
      class OptionHelpersCollection
        extend Forwardable
        def_delegators :@collection, :<<, :filter, :map, :find, :merge

        def initialize(collection = Set.new)
          @collection = collection
        end

        def dynamic_options
          OptionHelpersCollection.new(filter(&:dynamic_option?))
        end

        def find_by(name:)
          find { |helper| helper.name == name }
        end
      end
    end
  end
end
