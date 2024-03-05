# frozen_string_literal: true

module Servactory
  module ToolKit
    module DynamicOptions
      class Min < Base
        def self.setup
          new(:min).setup(:be_greater_than_or_equal_to)
        end

        def condition_with(value, received_value)
          case value.class
          when Integer
            value >= received_value
          when String, Array
            value.size >= received_value
          else
            false
          end
        end

        def message_for(service_class_name:, attribute_name:, input_name:, value:, received_value:, **)
          "[#{service_class_name}] #{attribute_name} attribute `#{input_name}` " \
            "received value `#{value}`, which is less than `#{received_value}`"
        end
      end
    end
  end
end
