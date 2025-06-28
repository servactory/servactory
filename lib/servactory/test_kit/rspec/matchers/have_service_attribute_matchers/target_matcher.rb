# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Matchers
        module HaveServiceAttributeMatchers
          class TargetMatcher
            OPTION_NAME = :target
            OPTION_BODY_KEY = :in

            attr_reader :missing_option

            def initialize(described_class, attribute_type, attribute_name, values)
              @described_class = described_class
              @attribute_type = attribute_type
              @attribute_type_plural = attribute_type.to_s.pluralize.to_sym
              @attribute_name = attribute_name
              @values = values

              @attribute_data = described_class.info.public_send(attribute_type_plural).fetch(attribute_name)

              @missing_option = ""
            end

            def description
              "target: #{values.map { |v| v.respond_to?(:name) ? v.name : v.to_s }.join(', ')}"
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
                        :values,
                        :attribute_data

            def submatcher_passes?(_subject)
              attribute_target = attribute_data.fetch(OPTION_NAME)
              attribute_target_in = attribute_target.fetch(OPTION_BODY_KEY)

              expected = values.respond_to?(:difference) ? values : [values]
              actual = attribute_target_in.respond_to?(:difference) ? attribute_target_in : [attribute_target_in]

              actual.difference(expected).empty? &&
                expected.difference(actual).empty?
            end

            def build_missing_option
              attribute_target = attribute_data.fetch(OPTION_NAME)
              attribute_target_in = attribute_target.fetch(OPTION_BODY_KEY)

              <<~MESSAGE
                should include the expected target values

                  expected #{values.inspect}
                       got #{attribute_target_in.inspect}
              MESSAGE
            end
          end
        end
      end
    end
  end
end
