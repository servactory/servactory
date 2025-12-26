# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Matchers
        module Submatchers
          module Input
            class DefaultSubmatcher < Base::Submatcher
              def initialize(context, expected_value)
                super(context)
                @expected_value = expected_value
              end

              def description
                "default: #{expected_value.inspect}"
              end

              protected

              def passes?
                actual_default = attribute_data.fetch(:default)
                @actual_value = actual_default

                return expected_value.nil? if actual_default.is_a?(NilClass)

                actual_default.to_s.casecmp(expected_value.to_s).zero?
              end

              def build_failure_message
                <<~MESSAGE
                  should have a default value

                    expected #{expected_value.inspect}
                         got #{@actual_value.inspect}
                MESSAGE
              end

              private

              attr_reader :expected_value
            end
          end
        end
      end
    end
  end
end
