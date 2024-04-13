# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Matchers
        module HaveServiceInputMatchers
          class TypesMatcher
            attr_reader :missing_option

            def initialize(described_class, input_name, types)
              @described_class = described_class
              @input_name = input_name
              @types = types

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

            attr_reader :described_class, :input_name, :types

            def submatcher_passes?(_subject)
              input_data = described_class.info.inputs.fetch(input_name)
              input_types = input_data.fetch(:types)

              input_types.difference(types).empty? && types.difference(input_types).empty?
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
