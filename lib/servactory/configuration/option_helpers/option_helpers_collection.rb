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
      # ## Inheritance
      #
      # A collection accepts one helper per name. A duplicate, made when
      # a service class is inherited, may replace a helper registered before
      # duplication in place without affecting the original.
      #
      # ## Usage
      #
      # The collection is used internally by the configuration system
      # to manage registered option helpers:
      #
      # ```ruby
      # collection = OptionHelpersCollection.new(builtin_helpers)
      # collection.register(helper)       # => :registered
      # collection << other_helper        # => collection, or raises ArgumentError
      # collection.merge([third_helper])  # => collection, or raises ArgumentError
      #
      # collection.find_by(name: :must)   # => helper instance
      # collection.dynamic_options        # => filtered OptionHelpersCollection
      # ```
      #
      # ## Enumeration
      #
      # The collection includes Enumerable and yields helpers in registration
      # order. Enumerable methods return plain values rather than collections:
      # `filter` and `map` return Arrays, `find` returns a helper or nil, and
      # `each_with_object` returns the memo object. Use `dynamic_options`
      # to get a filtered OptionHelpersCollection.
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
          @own_names = Set.new
        end

        # Duplicates the collection so that registrations do not leak into the original.
        #
        # Helpers of the original may be replaced once in the duplicate.
        #
        # @param original [OptionHelpersCollection] the collection being duplicated
        # @return [void]
        def initialize_dup(original)
          super
          @helpers = original.instance_variable_get(:@helpers).dup
          @own_names = Set.new
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
        # A helper with a new name is appended; a helper replacing one registered
        # before duplication keeps its position. The helpers are left unchanged
        # unless the result is `:registered`.
        #
        # @param helper [Maintenance::Options::Helper] the helper to register
        # @return [Symbol] `:registered`, `:skipped` when this very helper is
        #   already registered, `:reserved` when the name belongs to a built-in helper,
        #   or `:duplicated` when this collection already registered the name itself
        #   since it was created or duplicated
        def register(helper)
          name = helper.name

          if @helpers[name].equal?(helper)
            @own_names << name
            return :skipped
          end

          return :reserved if @builtin_names.include?(name)
          return :duplicated if @own_names.include?(name)

          @own_names << name
          @helpers[name] = helper
          :registered
        end

        # Registers a helper under its name, raising when the name is rejected.
        #
        # Follows `register`: re-adding this very helper is a no-op, and a helper
        # registered before duplication may be replaced once.
        #
        # @param helper [Maintenance::Options::Helper] the helper to register
        # @return [OptionHelpersCollection] self
        # @raise [ArgumentError] when the name belongs to a built-in helper
        #   or this collection already registered the name itself
        def <<(helper)
          case register(helper)
          when :reserved
            raise_error_about_reserved_name_with(helper.name)
          when :duplicated
            raise_error_about_duplicated_name_with(helper.name)
          end

          self
        end

        # Registers every helper of the given enumerables in order with `<<`.
        #
        # Helpers preceding a rejected one stay registered.
        #
        # @param enums [Array<Enumerable<Maintenance::Options::Helper>>] the helpers to register
        # @return [OptionHelpersCollection] self
        # @raise [ArgumentError] when `<<` rejects a helper
        def merge(*enums)
          enums.each { |helpers| helpers.each { |helper| self << helper } }
          self
        end

        # Returns a new collection containing only dynamic option helpers.
        #
        # @return [OptionHelpersCollection] filtered collection of dynamic helpers
        def dynamic_options
          each_with_object(OptionHelpersCollection.new) do |helper, collection|
            collection.register(helper) if helper.dynamic_option?
          end
        end

        # Finds a helper by its name with a direct Hash lookup.
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

        private

        # Raises an error about a name that belongs to a built-in helper.
        #
        # @param name [Symbol] the rejected helper name
        # @raise [ArgumentError] always
        def raise_error_about_reserved_name_with(name)
          raise ArgumentError,
                "The `#{name}` option helper name is reserved by a built-in option helper. " \
                "See configuration example here: https://servactory.com/guide/configuration"
        end

        # Raises an error about a name this collection already registered itself.
        #
        # @param name [Symbol] the rejected helper name
        # @raise [ArgumentError] always
        def raise_error_about_duplicated_name_with(name)
          raise ArgumentError,
                "The `#{name}` option helper is already registered in this collection. " \
                "See configuration example here: https://servactory.com/guide/configuration"
        end
      end
    end
  end
end
