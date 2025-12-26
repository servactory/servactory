# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Matchers
        module Concerns
          module ErrorMessageBuilder
            extend ActiveSupport::Concern

            def build_diff_message(expected:, actual:, prefix: "")
              <<~MESSAGE
                #{prefix}
                  expected: #{format_value(expected)}
                       got: #{format_value(actual)}
              MESSAGE
            end

            def format_value(value)
              case value
              when Array
                "[#{value.map { |v| format_value(v) }.join(', ')}]"
              when Hash
                value.inspect
              when Class
                value.name
              when nil
                "nil"
              else
                value.inspect
              end
            end

            def build_list_message(items, prefix: "")
              return "#{prefix}(empty)" if items.empty?

              "#{prefix}#{items.join(', ')}"
            end
          end
        end
      end
    end
  end
end
