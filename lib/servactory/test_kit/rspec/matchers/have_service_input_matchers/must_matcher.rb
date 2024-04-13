# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Matchers
        module HaveServiceInputMatchers
          class MustMatcher
            attr_reader :missing_option

            def initialize(described_class, input_name, must_names)
              @described_class = described_class
              @input_name = input_name
              @must_names = must_names

              @missing_option = ""
            end

            def description
              "must: #{must_names.join(', ')}"
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

            attr_reader :described_class, :input_name, :must_names

            def submatcher_passes?(_subject)
              input_data = described_class.info.inputs.fetch(input_name)
              input_must = input_data.fetch(:must)

              input_must.keys.difference(must_names).empty? &&
                must_names.difference(input_must.keys).empty?
            end

            def build_missing_option
              "should #{must_names.join(', ')}"
            end
          end
        end
      end
    end
  end
end
