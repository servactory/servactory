# frozen_string_literal: true

module Servactory
  module Configuration
    module OptionHelpers
      # Collection wrapper for managing option helper objects.
      #
      # ## Purpose
      #
      # OptionHelpersCollection provides a unified interface for storing and
      # querying Helper instances used by the configuration system.
      # It wraps a Set to ensure uniqueness and delegates common enumeration methods.
      #
      # ## Usage
      #
      # The collection is used internally by the configuration system
      # to manage registered option helpers:
      #
      # ```ruby
      # collection = OptionHelpersCollection.new
      # collection << helper
      #
      # collection.find_by(name: :must)   # => helper instance
      # collection.dynamic_options        # => filtered OptionHelpersCollection
      # ```
      #
      # ## Performance
      #
      # The collection uses memoization for frequently accessed data:
      # - `helpers_index` - cached hash for O(1) lookups by name
      #
      class OptionHelpersCollection
        extend Forwardable

        def_delegators :@collection, :<<, :filter, :each, :each_with_object, :map, :find, :merge

        # Initializes the collection with an optional pre-built Set.
        #
        # @param collection [Set] initial set of helpers
        # @return [OptionHelpersCollection]
        def initialize(collection = Set.new)
          @collection = collection
        end

        # Duplicates the collection, resetting memoized caches.
        #
        # @param original [OptionHelpersCollection] the collection being duplicated
        # @return [void]
        def initialize_dup(original)
          super
          @collection = original.instance_variable_get(:@collection).dup
          @helpers_index = nil
        end

        # Returns a new collection containing only dynamic option helpers.
        #
        # @return [OptionHelpersCollection] filtered collection of dynamic helpers
        def dynamic_options
          OptionHelpersCollection.new(filter(&:dynamic_option?))
        end

        # Finds a helper by its name using indexed lookup.
        #
        # @param name [Symbol] the helper name to find
        # @return [Maintenance::Options::Helper, nil] the found helper or nil
        def find_by(name:)
          helpers_index[name]
        end

        private

        # Builds and caches a hash index for O(1) helper lookups.
        #
        # @return [Hash{Symbol => Maintenance::Options::Helper}] helper names mapped to Helper instances
        def helpers_index
          @helpers_index ||= each_with_object({}) do |helper, index|
            index[helper.name] = helper
          end
        end
      end
    end
  end
end
