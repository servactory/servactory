# frozen_string_literal: true

module Servactory
  module Stroma
    module Hooks
      # Mutable collection manager for Hook objects.
      #
      # ## Purpose
      #
      # Stores Hook objects and provides query methods to retrieve hooks
      # by type and target key. Supports proper duplication during class
      # inheritance to ensure configuration isolation.
      #
      # ## Usage
      #
      # ```ruby
      # hooks = Servactory::Stroma::Hooks::Collection.new
      # hooks.add(:before, :actions, MyModule)
      # hooks.add(:after, :actions, AnotherModule)
      #
      # hooks.before(:actions)  # => [Hook(...)]
      # hooks.after(:actions)   # => [Hook(...)]
      # hooks.empty?            # => false
      # hooks.size              # => 2
      # ```
      #
      # ## Integration
      #
      # Stored in Servactory::Stroma::State and used by
      # Servactory::Stroma::Hooks::Applier to apply hooks to classes.
      # Properly duplicated during class inheritance via initialize_dup.
      class Collection
        extend Forwardable

        # @!method each
        #   Iterates over all hooks in the collection.
        #   @yield [Hook] Each hook in the collection
        # @!method map
        #   Maps over all hooks in the collection.
        #   @yield [Hook] Each hook in the collection
        #   @return [Array] Mapped results
        # @!method size
        #   Returns the number of hooks in the collection.
        #   @return [Integer] Number of hooks
        # @!method empty?
        #   Checks if the collection is empty.
        #   @return [Boolean] true if no hooks registered
        def_delegators :@collection, :each, :map, :size, :empty?

        # Creates a new hooks collection.
        #
        # @param collection [Set] Initial collection of hooks (default: empty Set)
        def initialize(collection = Set.new)
          @collection = collection
        end

        # Creates a deep copy during inheritance.
        #
        # @param original [Collection] The original collection being duplicated
        # @return [void]
        def initialize_dup(original)
          super
          @collection = original.instance_variable_get(:@collection).dup
        end

        # Adds a new hook to the collection.
        #
        # @param type [Symbol] Hook type (:before or :after)
        # @param target_key [Symbol] Registry key to hook into
        # @param extension [Module] Extension module to include
        # @return [Set] The updated collection
        #
        # @example
        #   hooks.add(:before, :actions, ValidationModule)
        def add(type, target_key, extension)
          @collection << Hook.new(type:, target_key:, extension:)
        end

        # Returns all before hooks for a given key.
        #
        # @param key [Symbol] The target key to filter by
        # @return [Array<Hook>] Hooks that run before the target
        #
        # @example
        #   hooks.before(:actions)  # => [Hook(type: :before, ...)]
        def before(key)
          @collection.select { |hook| hook.before? && hook.target_key == key }
        end

        # Returns all after hooks for a given key.
        #
        # @param key [Symbol] The target key to filter by
        # @return [Array<Hook>] Hooks that run after the target
        #
        # @example
        #   hooks.after(:actions)  # => [Hook(type: :after, ...)]
        def after(key)
          @collection.select { |hook| hook.after? && hook.target_key == key }
        end
      end
    end
  end
end
