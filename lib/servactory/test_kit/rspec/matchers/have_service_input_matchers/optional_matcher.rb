# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Matchers
        module HaveServiceInputMatchers
          class OptionalMatcher
            attr_reader :missing_option

            def initialize(described_class, input_name)
              @described_class = described_class
              @input_name = input_name

              @missing_option = ""
            end

            def description
              "required: false"
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

            attr_reader :described_class, :input_name

            def submatcher_passes?(_subject)
              input_data = described_class.info.inputs.fetch(input_name)
              input_required = input_data.fetch(:required).fetch(:is)

              input_required == false
            end

            def build_missing_option
              "should be optional"
            end
          end
        end
      end
    end
  end
end
