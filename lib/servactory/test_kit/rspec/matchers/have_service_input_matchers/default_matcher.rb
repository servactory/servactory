# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Matchers
        module HaveServiceInputMatchers
          class DefaultMatcher
            attr_reader :missing_option

            def initialize(described_class, input_name, default_value)
              @described_class = described_class
              @input_name = input_name
              @default_value = default_value

              @missing_option = ""
            end

            def description
              "default: #{default_value.inspect}"
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

            attr_reader :described_class, :input_name, :default_value

            def submatcher_passes?(_subject)
              input_data = described_class.info.inputs.fetch(input_name)
              input_default_value = input_data.fetch(:default)

              input_default_value.casecmp(default_value).zero?
            end

            def build_missing_option
              "should have a default value of #{default_value.inspect}"
            end
          end
        end
      end
    end
  end
end
