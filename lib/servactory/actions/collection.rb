# frozen_string_literal: true

module Servactory
  module Actions
    # Mutable collection manager for Action objects.
    #
    # ## Purpose
    #
    # Stores Action objects and provides query methods to retrieve actions
    # sorted by position. Wraps a Set for unique action storage with
    # position-based ordering capabilities.
    #
    # ## Usage
    #
    # ```ruby
    # actions = Servactory::Actions::Collection.new
    # actions << Action.new(:first, position: 1)
    # actions << Action.new(:second, position: 2)
    #
    # actions.sorted_by_position  # => Collection with sorted actions
    # actions.empty?              # => false
    # actions.size                # => 2
    # ```
    #
    # ## Integration
    #
    # Used by Servactory::Actions::Stages::Stage to store actions within
    # a stage, and by Servactory::Actions::Tools::Runner to execute
    # actions in the correct order.
    class Collection
      extend Forwardable

      # @!method <<(action)
      #   Adds an action to the collection.
      #   @param action [Action] The action to add
      #   @return [Set] The updated collection
      # @!method each
      #   Iterates over all actions in the collection.
      #   @yield [Action] Each action in the collection
      # @!method to_h
      #   Converts collection to a hash.
      #   @return [Hash] Hash representation
      # @!method sort_by
      #   Sorts actions by the given block.
      #   @yield [Action] Each action for comparison
      #   @return [Array<Action>] Sorted array of actions
      # @!method size
      #   Returns the number of actions in the collection.
      #   @return [Integer] Number of actions
      # @!method empty?
      #   Checks if the collection is empty.
      #   @return [Boolean] true if no actions registered
      def_delegators :@collection, :<<, :each, :to_h, :sort_by, :size, :empty?

      # Creates a new actions collection.
      #
      # @param collection [Set] Initial collection of actions (default: empty Set)
      def initialize(collection = Set.new)
        @collection = collection
      end

      # Returns a new collection with actions sorted by position.
      #
      # @return [Collection] New collection with actions in position order
      #
      # @example
      #   sorted = actions.sorted_by_position
      #   sorted.each { |action| puts action.position }
      def sorted_by_position
        @sorted_by_position ||= Collection.new(sort_by(&:position))
      end
    end
  end
end
