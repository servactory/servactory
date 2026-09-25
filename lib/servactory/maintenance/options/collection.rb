# frozen_string_literal: true

module Servactory
  module Maintenance
    module Options
      # Collection wrapper for managing Option objects.
      #
      # ## Purpose
      #
      # Collection provides a unified interface for storing and querying
      # Option instances associated with service attributes (inputs, internals, outputs).
      # It wraps a Set to ensure uniqueness and delegates common enumeration methods.
      #
      # ## Usage
      #
      # The collection is used internally by Input, Internal, and Output classes
      # to manage their registered options:
      #
      # ```ruby
      # collection = Collection.new
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
      # - `validations_for_checks` - cached tuples for validation pipeline
      # - `options_index` - cached hash for O(1) lookups by name
      #
      class Collection
        extend Forwardable

        def_delegators :@collection,
                       :filter,
                       :each, :each_with_object,
                       :map,
                       :size,
                       :empty?

        # Initializes an empty collection.
        #
        # @return [Collection]
        def initialize
          @collection = Set.new
        end

        # Duplicates the collection, resetting memoized caches.
        #
        # @param original [Collection] the collection being duplicated
        # @return [void]
        def initialize_dup(original)
          super
          @collection = original.instance_variable_get(:@collection).dup
          reset_memoized_caches
        end

        # Adds an option to the collection, invalidating memoized caches.
        #
        # @param option [Option] the option to add
        # @return [Collection] self
        def <<(option)
          @collection << option
          reset_memoized_caches
          self
        end

        # Returns all option names in the collection.
        #
        # @return [Array<Symbol>] list of option names
        def names
          map(&:name)
        end

        # @deprecated Use {#validations_for_checks} instead.
        #
        # @return [Array<Class>] deduplicated list of validation classes
        def validation_classes
          warn "[DEPRECATION] Servactory::Maintenance::Options::Collection#validation_classes is deprecated. " \
               "Use #validations_for_checks instead."
          validations_for_checks.map(&:last).uniq
        end

        # @deprecated Use {#validations_for_checks} instead.
        #
        # @return [Hash{Symbol => Object}] option names mapped to normalized bodies
        def options_for_checks
          warn "[DEPRECATION] Servactory::Maintenance::Options::Collection#options_for_checks is deprecated. " \
               "Use #validations_for_checks instead."
          validations_for_checks.to_h { |check_key, check_options, _| [check_key, check_options] }
        end

        # Returns options that need validation checks as an array of tuples.
        # Each tuple contains [check_key, check_options, validation_class],
        # enabling direct dispatch without nested iteration.
        #
        # @return [Array<Array(Symbol, Object, Class)>] tuples for direct validation dispatch
        def validations_for_checks
          @validations_for_checks ||= filter(&:need_for_checks?).filter_map do |option|
            next if option.validation_class.nil?

            [option.name, extract_normalized_body_from(option:), option.validation_class]
          end
        end

        # Returns the first conflict code found among options.
        #
        # @return [Symbol, nil] conflict code or nil if no conflicts
        def defined_conflict_code
          each do |option|
            next unless option.define_conflicts

            option.define_conflicts.each do |conflict|
              code = conflict.content.call
              return code if code.present?
            end
          end

          nil
        end

        # Finds an option by its name using indexed lookup.
        #
        # @param name [Symbol] the option name to find
        # @return [Option, nil] the found option or nil
        def find_by(name:)
          options_index[name]
        end

        private

        # Resets memoized data derived from the collection contents.
        #
        # @return [void]
        def reset_memoized_caches
          @validations_for_checks = nil
          @options_index = nil
        end

        # Builds and caches a hash index for O(1) option lookups.
        #
        # @return [Hash{Symbol => Option}] option names mapped to Option instances
        def options_index
          @options_index ||= @collection.to_h { |option| [option.name, option] }
        end

        # Extracts the normalized body value from an option.
        #
        # @param option [Option] the option to extract from
        # @return [Object] the body_key value if body is a Hash, otherwise the full body
        def extract_normalized_body_from(option:)
          option.value
        end
      end
    end
  end
end
