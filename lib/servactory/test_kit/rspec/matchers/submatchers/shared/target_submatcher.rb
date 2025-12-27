# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Matchers
        module Submatchers
          module Shared
            class TargetSubmatcher < Base::Submatcher
              OPTION_BODY_KEY = :in

              def initialize(context, option_name, values)
                super(context)
                @option_name = option_name
                @values = values
              end

              def description
                "#{option_name}: #{formatted_values}"
              end

              protected

              def passes?
                return false unless attribute_target.is_a?(Hash)
                return false if attribute_target_in.nil?

                expected = normalize_to_array(values)
                actual = normalize_to_array(attribute_target_in)

                actual.difference(expected).empty? && expected.difference(actual).empty?
              end

              def build_failure_message
                <<~MESSAGE
                  should include the expected #{option_name} values

                    expected #{values.inspect}
                         got #{attribute_target_in.inspect}
                MESSAGE
              end

              private

              attr_reader :option_name,
                          :values

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

              def normalize_to_array(value)
                value.respond_to?(:difference) ? value : [value]
              end
            end
          end
        end
      end
    end
  end
end
