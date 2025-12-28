# frozen_string_literal: true

module Servactory
  module TestKit
    module Utils
      # Generates fake test values for different Ruby types.
      #
      # ## Purpose
      #
      # Provides fake values for testing input validations. Used by
      # ValidWithSubmatcher to generate values that will trigger specific
      # validation failures (e.g., wrong inclusion values).
      #
      # ## Usage
      #
      # ```ruby
      # # Get a fake value for a type
      # Faker.fetch_value_for(String)  # => "fake"
      # Faker.fetch_value_for(Integer) # => 123
      # Faker.fetch_value_for(Array, of: :integer) # => [1, 2, 3]
      # ```
      #
      # ## Supported Types
      #
      # - Symbol - returns `:fake`
      # - String - returns `"fake"`
      # - Integer - returns `123`
      # - Float - returns `12.3`
      # - Range - returns `1..3`
      # - Array - returns `["fake"]` or `[1, 2, 3]` based on `of:` param
      # - Hash - returns `{ fake: :yes }` or `{ fake: 1 }` based on `of:` param
      # - TrueClass - returns `true`
      # - FalseClass - returns `false`
      # - NilClass - returns `nil`
      module Faker
        extend self

        # Generates a fake value for the given type.
        #
        # @param class_or_name [Class, String] Type to generate value for
        # @param of [Symbol] Element type for Array/Hash (:string or :integer)
        # @return [Object] Fake value of the requested type
        def fetch_value_for(class_or_name, of: :string) # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
          class_for_fake = Servactory::Utils.constantize_class(class_or_name)
          of = of.to_sym

          faker = {
            Symbol => method(:fake_symbol),
            String => method(:fake_string),
            Integer => method(:fake_integer),
            Float => method(:fake_float),
            Range => method(:fake_range),
            Array => -> { fake_array(of) },
            Hash => -> { fake_hash(of) },
            TrueClass => method(:fake_true_class),
            FalseClass => method(:fake_false_class),
            NilClass => method(:fake_nil_class)
          }

          fake_class = faker[class_for_fake] || -> { unsupported_faker(class_for_fake) }
          fake_class.call
        end

        private

        # Returns fake Symbol value.
        # @return [Symbol]
        def fake_symbol
          :fake
        end

        # Returns fake String value.
        # @return [String]
        def fake_string
          "fake"
        end

        # Returns fake Integer value.
        # @return [Integer]
        def fake_integer
          123
        end

        # Returns fake Float value.
        # @return [Float]
        def fake_float
          12.3
        end

        # Returns fake Range value.
        # @return [Range]
        def fake_range
          1..3
        end

        # Returns fake Array value.
        # @param of [Symbol] Element type (:string or :integer)
        # @return [Array]
        def fake_array(of)
          of == :integer ? [1, 2, 3] : ["fake"]
        end

        # Returns fake Hash value.
        # @param of [Symbol] Value type (:string or :integer)
        # @return [Hash]
        def fake_hash(of)
          of == :integer ? { fake: 1 } : { fake: :yes }
        end

        # Returns true (fake TrueClass value).
        # @return [Boolean]
        def fake_true_class # rubocop:disable Naming/PredicateMethod
          true
        end

        # Returns false (fake FalseClass value).
        # @return [Boolean]
        def fake_false_class # rubocop:disable Naming/PredicateMethod
          false
        end

        # Returns nil (fake NilClass value).
        # @return [nil]
        def fake_nil_class
          nil
        end

        # Handles unsupported types by attempting to instantiate them.
        #
        # @param class_for_fake [Class] The unsupported type class
        # @return [Object] New instance or the class itself
        def unsupported_faker(class_for_fake)
          class_for_fake.respond_to?(:new) ? class_for_fake.new : class_for_fake
        end
      end
    end
  end
end
