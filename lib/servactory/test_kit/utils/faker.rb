# frozen_string_literal: true

module Servactory
  module TestKit
    module Utils
      module Faker
        extend self

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

        def fake_symbol
          :fake
        end

        def fake_string
          "fake"
        end

        def fake_integer
          123
        end

        def fake_float
          12.3
        end

        def fake_range
          1..3
        end

        def fake_array(of)
          of == :integer ? [1, 2, 3] : ["fake"]
        end

        def fake_hash(of)
          of == :integer ? { fake: 1 } : { fake: :yes }
        end

        def fake_true_class # rubocop:disable Naming/PredicateMethod
          true
        end

        def fake_false_class # rubocop:disable Naming/PredicateMethod
          false
        end

        def fake_nil_class
          nil
        end

        def unsupported_faker(class_for_fake)
          class_for_fake.respond_to?(:new) ? class_for_fake.new : class_for_fake
        end
      end
    end
  end
end
