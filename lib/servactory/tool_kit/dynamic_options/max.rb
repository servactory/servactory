# frozen_string_literal: true

module Servactory
  module ToolKit
    module DynamicOptions
      class Max < Base
        def self.setup
          new(:min).setup
        end

        def equivalent # rubocop:disable Metrics/MethodLength
          lambda do |data|
            received_value = (data.is_a?(Hash) && data.key?(:is) ? data[:is] : data)

            {
              must: {
                be_less_than_or_equal_to: {
                  is: ->(value:) { value <= received_value },
                  message: lambda do |service_class_name:, input:, value:, **|
                    "[#{service_class_name}] #{input.system_name.to_s.titleize} attribute `#{input.name}` " \
                      "received value `#{value}`, which is greater than `#{received_value}`"
                  end
                }
              }
            }
          end
        end
      end
    end
  end
end
