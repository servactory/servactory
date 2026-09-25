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
      # It keeps helpers in an insertion-ordered Hash keyed by helper name,
      # so every name resolves to exactly one helper.
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
      # Registration and lookup by name are O(1) Hash operations without
      # cached indexes, so helpers registered after attributes are declared
      # are visible to subsequent declarations.
      #
      class OptionHelpersCollection
        include Enumerable

        # Initializes the collection with optional initial helpers.
        #
        # @param collection [Enumerable<Maintenance::Options::Helper>] initial helpers
        # @return [OptionHelpersCollection]
        def initialize(collection = [])
          @helpers = collection.to_h { |helper| [helper.name, helper] }
        end

        # Duplicates the collection so that registrations do not leak into the original.
        #
        # @param original [OptionHelpersCollection] the collection being duplicated
        # @return [void]
        def initialize_dup(original)
          super
          @helpers = original.instance_variable_get(:@helpers).dup
        end

        # Iterates over helpers in registration order.
        #
        # @yieldparam helper [Maintenance::Options::Helper] each registered helper
        # @return [OptionHelpersCollection, Enumerator] self, or an enumerator without a block
        def each(&block)
          return enum_for(:each) unless block_given?

          @helpers.each_value(&block)
          self
        end

        # Registers a helper under its name, replacing a helper with the same name in place.
        #
        # @param helper [Maintenance::Options::Helper] the helper to register
        # @return [OptionHelpersCollection] self
        def <<(helper)
          @helpers[helper.name] = helper
          self
        end

        # Registers each helper in order.
        #
        # @param helpers [Enumerable<Maintenance::Options::Helper>] helpers to register
        # @return [OptionHelpersCollection] self
        def merge(helpers)
          helpers.each { |helper| self << helper }
          self
        end

        # Returns a new collection containing only dynamic option helpers.
        #
        # @return [OptionHelpersCollection] filtered collection of dynamic helpers
        def dynamic_options
          OptionHelpersCollection.new(select(&:dynamic_option?))
        end

        # Finds a helper by its name using indexed lookup.
        #
        # @param name [Symbol] the helper name to find
        # @return [Maintenance::Options::Helper, nil] the found helper or nil
        def find_by(name:)
          @helpers[name]
        end

        # Replaces a helper by name with a new one, keeping its position.
        #
        # @param name [Symbol] the helper name to replace
        # @param with [Maintenance::Options::Helper] the replacement helper
        # @return [void]
        def replace(name:, with:)
          return unless @helpers.key?(name)

          @helpers[name] = with
        end
      end
    end
  end
end
