# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Matchers
        module HaveServiceAttributeMatchers
          class TargetMatcher
            OPTION_BODY_KEY = :in

            attr_reader :missing_option

            def initialize(described_class, attribute_type, attribute_name, option_name, values)
              @described_class = described_class
              @attribute_type = attribute_type
              @attribute_type_plural = attribute_type.to_s.pluralize.to_sym
              @attribute_name = attribute_name
              @option_name = option_name
              @values = values

              @attribute_data = described_class.info.public_send(attribute_type_plural).fetch(attribute_name)

              @missing_option = ""
            end

            def description
              "#{option_name}: #{formatted_values}"
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
                        :attribute_data,
                        :option_name

            def formatted_values
              values.map do |v|
                case v
                when nil then "nil"
                when Class then v.name
                else v.to_s
                end
              end.join(", ")
            end

            def attribute_target
              @attribute_target ||= attribute_data[option_name]
            end

            def attribute_target_in
              return @attribute_target_in if defined?(@attribute_target_in)

              @attribute_target_in = attribute_target&.dig(OPTION_BODY_KEY)
            end

            def submatcher_passes?(_subject)
              return false unless attribute_target.is_a?(Hash)
              return false if attribute_target_in.nil?

              expected = normalize_to_array(values)
              actual = normalize_to_array(attribute_target_in)

              actual.difference(expected).empty? && expected.difference(actual).empty?
            end

            def normalize_to_array(value)
              value.respond_to?(:difference) ? value : [value]
            end

            def build_missing_option
              <<~MESSAGE
                should include the expected #{option_name} values

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
