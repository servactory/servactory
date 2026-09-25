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
      # ## Built-in Helpers
      #
      # Helpers passed to the constructor are built-in: their names are
      # reserved, and only `replace` may swap them (used to rebind built-in
      # dynamic options to the configuration of a subclass).
      #
      # ## Usage
      #
      # The collection is used internally by the configuration system
      # to manage registered option helpers:
      #
      # ```ruby
      # collection = OptionHelpersCollection.new(builtin_helpers)
      # collection.register(helper)       # => :registered
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

        # Initializes the collection with built-in helpers.
        #
        # @param builtin_helpers [Enumerable<Maintenance::Options::Helper>] helpers whose names are reserved
        # @return [OptionHelpersCollection]
        def initialize(builtin_helpers = [])
          @helpers = builtin_helpers.to_h { |helper| [helper.name, helper] }
          @builtin_names = @helpers.keys.to_set.freeze
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

        # Registers a helper under its name.
        #
        # A helper with a new name is appended; a helper replacing a non-built-in
        # one keeps its position. The collection is left unchanged unless the
        # result is `:registered`.
        #
        # @param helper [Maintenance::Options::Helper] the helper to register
        # @return [Symbol] `:registered`, `:skipped` when this very helper is
        #   already registered, or `:reserved` when the name belongs to a built-in helper
        def register(helper)
          name = helper.name
          return :skipped if @helpers[name].equal?(helper)
          return :reserved if @builtin_names.include?(name)

          @helpers[name] = helper
          :registered
        end

        # Returns a new collection containing only dynamic option helpers.
        #
        # @return [OptionHelpersCollection] filtered collection of dynamic helpers
        def dynamic_options
          each_with_object(OptionHelpersCollection.new) do |helper, collection|
            collection.register(helper) if helper.dynamic_option?
          end
        end

        # Finds a helper by its name using indexed lookup.
        #
        # @param name [Symbol] the helper name to find
        # @return [Maintenance::Options::Helper, nil] the found helper or nil
        def find_by(name:)
          @helpers[name]
        end

        # Replaces a built-in helper by name with a new one, keeping its position.
        #
        # Names that do not belong to a built-in helper are ignored.
        #
        # @param name [Symbol] the built-in helper name to replace
        # @param with [Maintenance::Options::Helper] the replacement helper
        # @return [void]
        def replace(name:, with:)
          return unless @builtin_names.include?(name)

          @helpers[name] = with
        end
      end
    end
  end
end
