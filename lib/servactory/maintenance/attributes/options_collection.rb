# frozen_string_literal: true

module Servactory
  module Maintenance
    module Attributes
      # Collection wrapper for managing Option objects.
      #
      # ## Purpose
      #
      # OptionsCollection provides a unified interface for storing and querying
      # Option instances associated with service attributes (inputs, internals, outputs).
      # It wraps a Set to ensure uniqueness and delegates common enumeration methods.
      #
      # ## Usage
      #
      # The collection is used internally by Input, Internal, and Output classes
      # to manage their registered options:
      #
      # ```ruby
      # collection = OptionsCollection.new
      # collection << Option.new(name: :required, ...)
      # collection << Option.new(name: :types, ...)
      #
      # collection.names              # => [:required, :types]
      # collection.find_by(name: :required)  # => Option instance
      # ```
      #
      # ## Performance
      #
      # The collection uses memoization for frequently accessed data:
      # - `validation_classes` - cached list of unique validation classes
      # - `options_for_checks` - cached hash for validation pipeline
      # - `options_index` - cached hash for O(1) lookups by name
      #
      class OptionsCollection
        extend Forwardable

        def_delegators :@collection,
                       :<<,
                       :filter,
                       :each, :each_with_object,
                       :map, :flat_map,
                       :find,
                       :size,
                       :empty?

        # Initializes an empty collection.
        #
        # @return [OptionsCollection]
        def initialize
          @collection = Set.new
        end

        # Returns all option names in the collection.
        #
        # @return [Array<Symbol>] list of option names
        def names
          map(&:name)
        end

        # Returns unique validation classes from all options.
        #
        # @return [Array<Class>] deduplicated list of validation classes
        def validation_classes
          @validation_classes ||=
            filter { |option| option.validation_class.present? }
            .map(&:validation_class)
            .uniq
        end

        # Returns options that need validation checks as a hash.
        #
        # @return [Hash{Symbol => Object}] option names mapped to normalized bodies
        def options_for_checks
          @options_for_checks ||= filter(&:need_for_checks?).to_h do |option|
            [option.name, extract_normalized_body_from(option:)]
          end
        end

        # Returns the first conflict code found among options.
        #
        # @return [Object, nil] conflict code or nil if no conflicts
        def defined_conflict_code
          flat_map { |option| resolve_conflicts_from(option:) }
            .reject(&:blank?)
            .first
        end

        # Finds an option by its name using indexed lookup.
        #
        # @param name [Symbol] the option name to find
        # @return [Option, nil] the found option or nil
        def find_by(name:)
          options_index[name]
        end

        private

        # Builds and caches a hash index for O(1) option lookups.
        #
        # @return [Hash{Symbol => Option}] option names mapped to Option instances
        def options_index
          @options_index ||= each_with_object({}) do |option, index|
            index[option.name] = option
          end
        end

        # Extracts the normalized body value from an option.
        #
        # @param option [Option] the option to extract from
        # @return [Object] the :is value if body is a Hash with :is key, otherwise the full body
        def extract_normalized_body_from(option:)
          body = option.body
          return body unless body.is_a?(Hash)

          body.key?(:is) ? body.fetch(:is) : body
        end

        # Resolves conflict codes from an option's define_conflicts.
        #
        # @param option [Option] the option to check for conflicts
        # @return [Array<Object>] array of conflict codes (may contain nils/blanks)
        def resolve_conflicts_from(option:)
          return [] unless option.define_conflicts

          option.define_conflicts.map { |conflict| conflict.content.call }
        end
      end
    end
  end
end
