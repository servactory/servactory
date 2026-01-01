# frozen_string_literal: true

module Servactory
  module Stroma
    # Collection manager for Hook objects.
    #
    # ## Purpose
    #
    # Mutable collection that stores Hook objects and provides query methods
    # to retrieve hooks by type and target key.
    #
    # ## Usage
    #
    # ```ruby
    # hooks = Hooks.new
    # hooks.add(:before, :actions, MyModule)
    # hooks.add(:after, :actions, AnotherModule)
    #
    # hooks.before(:actions)  # => [Hook(...MyModule...)]
    # hooks.after(:actions)   # => [Hook(...AnotherModule...)]
    # hooks.empty?            # => false
    # ```
    #
    # ## Integration
    #
    # Stored in Configuration and used by Applier to apply hooks to classes.
    # Properly duplicated during class inheritance via initialize_dup.
    class Hooks
      extend Forwardable

      def_delegators :@collection, :each, :empty?, :size

      def initialize(collection = Set.new)
        @collection = collection
      end

      def initialize_dup(original)
        super
        @collection = original.instance_variable_get(:@collection).dup
      end

      def add(type, target_key, extension)
        @collection << Hook.new(type:, target_key:, extension:)
      end

      def before(key)
        @collection.select { |hook| hook.before? && hook.target_key == key }
      end

      def after(key)
        @collection.select { |hook| hook.after? && hook.target_key == key }
      end
    end
  end
end
