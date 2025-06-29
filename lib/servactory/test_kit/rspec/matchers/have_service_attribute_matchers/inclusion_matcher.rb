# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Matchers
        module HaveServiceAttributeMatchers
          class InclusionMatcher
            OPTION_NAME = :inclusion
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
              "inclusion: #{values.join(', ')}"
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
              attribute_inclusion = attribute_data.fetch(OPTION_NAME)
              attribute_inclusion_in = attribute_inclusion.fetch(OPTION_BODY_KEY)

              attribute_inclusion_in.difference(values).empty? &&
                values.difference(attribute_inclusion_in).empty?
            end

            def build_missing_option
              attribute_inclusion = attribute_data.fetch(OPTION_NAME)
              attribute_inclusion_in = attribute_inclusion.fetch(OPTION_BODY_KEY)

              <<~MESSAGE
                should include the expected values

                  expected #{values.inspect}
                       got #{attribute_inclusion_in.inspect}
              MESSAGE
            end
          end
        end
      end
    end
  end
end
