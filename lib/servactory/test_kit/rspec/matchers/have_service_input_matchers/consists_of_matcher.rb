# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Matchers
        module HaveServiceInputMatchers
          class ConsistsOfMatcher
            attr_reader :missing_option

            def initialize(described_class, input_name, input_types, consists_of_types)
              @described_class = described_class
              @input_name = input_name
              @input_types = input_types
              @consists_of_types = consists_of_types

              @missing_option = ""
            end

            def description
              result = "consists_of: "
              result + consists_of_types.join(", ")
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

            attr_reader :described_class, :input_name, :input_types, :consists_of_types

            def submatcher_passes?(_subject)
              input_data = described_class.info.inputs.fetch(input_name)
              input_consists_of = Array(input_data.fetch(:consists_of).fetch(:type) || [])
              _input_consists_of_message = input_data.fetch(:consists_of).fetch(:message)

              input_consists_of.difference(consists_of_types).empty?
            end

            def build_missing_option
              result = "should be a collection "
              result += input_types.size > 1 ? "of #{input_types.join(', ')} types, " : "of type #{input_types.first}, "
              result += consists_of_types.size > 1 ? "consisting of the following types: " : "consisting of type "
              result + consists_of_types.join(", ")
            end
          end
        end
      end
    end
  end
end
