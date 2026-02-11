# frozen_string_literal: true

module Servactory
  module Maintenance
    module Attributes
      # Collection wrapper for managing attribute objects (inputs, internals, outputs).
      #
      # ## Purpose
      #
      # Collection provides a polymorphic base for storing and querying attribute
      # instances. It wraps a Set to ensure uniqueness and delegates common
      # enumeration methods. Subclasses override `lookup_name` to customize
      # how attributes are indexed and filtered (e.g., inputs use `internal_name`
      # for the `as:` parameter).
      #
      # ## Usage
      #
      # Subclasses are used internally by Input, Internal, and Output DSL modules
      # to manage their registered attributes:
      #
      # ```ruby
      # collection = Collection.new
      # collection << attribute
      #
      # collection.names                      # => [:first_name, :last_name]
      # collection.find_by(name: :first_name) # => attribute instance
      # collection.only(:first_name)          # => filtered Collection
      # collection.except(:last_name)         # => filtered Collection
      # ```
      #
      # ## Performance
      #
      # The collection uses memoization for frequently accessed data:
      # - `attributes_index` - cached hash for O(1) lookups by name
      #
      class Collection
        extend Forwardable

        def_delegators :@collection, :<<, :filter, :each, :each_with_object, :map, :to_h, :merge, :find

        # Initializes the collection with an optional pre-built Set.
        #
        # @param collection [Set] initial set of attributes
        # @return [Collection]
        def initialize(collection = Set.new)
          @collection = collection
        end

        # Returns names of all attributes in the collection.
        #
        # @return [Array<Symbol>] list of attribute names
        def names
          map(&:name)
        end

        # Returns a new collection containing only the named attributes.
        #
        # @param names [Array<Symbol>] attribute names to include
        # @return [Collection] filtered collection
        def only(*names)
          self.class.new(filter { |attribute| names.include?(lookup_name(attribute)) })
        end

        # Returns a new collection excluding the named attributes.
        #
        # @param names [Array<Symbol>] attribute names to exclude
        # @return [Collection] filtered collection
        def except(*names)
          self.class.new(filter { |attribute| names.exclude?(lookup_name(attribute)) })
        end

        # Finds an attribute by its name using indexed lookup.
        #
        # @param name [Symbol] the attribute name to find
        # @return [Object, nil] the found attribute or nil
        def find_by(name:)
          attributes_index[name]
        end

        private

        # Builds and caches a hash index for O(1) attribute lookups.
        #
        # @return [Hash{Symbol => Object}] attribute names mapped to attribute instances
        def attributes_index
          @attributes_index ||= each_with_object({}) do |attribute, index|
            index[lookup_name(attribute)] = attribute
          end
        end

        # Returns the name used for indexing and filtering a given attribute.
        #
        # Subclasses override this to use alternative name fields
        # (e.g., `internal_name` for inputs with the `as:` parameter).
        #
        # @param attribute [Object] the attribute to extract a name from
        # @return [Symbol] the lookup name
        def lookup_name(attribute)
          attribute.name
        end
      end
    end
  end
end
