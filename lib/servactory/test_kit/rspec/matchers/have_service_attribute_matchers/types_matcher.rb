# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Matchers
        module HaveServiceAttributeMatchers
          class TypesMatcher
            attr_reader :missing_option

            def initialize(described_class, attribute_type, attribute_name, types)
              @described_class = described_class
              @attribute_type = attribute_type
              @attribute_type_plural = attribute_type.to_s.pluralize.to_sym
              @attribute_name = attribute_name
              @types = types

              @attribute_data = described_class.info.public_send(attribute_type_plural).fetch(attribute_name)

              @missing_option = ""
            end

            def description
              result = "type"
              result += types.size > 1 ? "s: " : ": "
              result + types.join(", ")
            end

            def matches?(subject)
              if submatcher_passes?(subject)
                true
              else
                @missing_option = build_missing_option

                false
              end
            end

            private

            attr_reader :described_class,
                        :attribute_type,
                        :attribute_type_plural,
                        :attribute_name,
                        :types,
                        :attribute_data

            def submatcher_passes?(_subject)
              option_types = attribute_data.fetch(:types)

              option_types.difference(types).empty? &&
                types.difference(option_types).empty?
            end

            def build_missing_option
              result = "should have a value "
              result += types.size > 1 ? "with one of the following types: " : "of type "
              result + types.join(", ")
            end
          end
        end
      end
    end
  end
end
