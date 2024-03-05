# frozen_string_literal: true

module Servactory
  module ToolKit
    module DynamicOptions
      class Min < Base
        def self.setup
          new(:min).setup(:be_greater_than_or_equal_to)
        end

        def must_content_with(received_value) # rubocop:disable Metrics/MethodLength
          {
            is: ->(value:) { value >= received_value },
            message: lambda do |service_class_name:, input:, value:, **|
              message_for(
                service_class_name: service_class_name,
                attribute_name: input.system_name.to_s.titleize,
                input_name: input.name,
                value: value,
                received_value: received_value
              )
            end
          }
        end

        def message_for(service_class_name:, attribute_name:, input_name:, value:, received_value:)
          "[#{service_class_name}] #{attribute_name} attribute `#{input_name}` " \
            "received value `#{value}`, which is less than `#{received_value}`"
        end
      end
    end
  end
end
