# frozen_string_literal: true

module Servactory
  module ToolKit
    module DynamicOptions
      class Base
        def initialize(option_name)
          @option_name = option_name
        end

        def setup(name)
          Servactory::Maintenance::Attributes::OptionHelper.new(
            name: @option_name,
            equivalent: equivalent_with(name)
          )
        end

        def equivalent_with(name)
          lambda do |data|
            received_value = (data.is_a?(Hash) && data.key?(:is) ? data[:is] : data)

            {
              must: {
                name => must_content_with(received_value)
              }
            }
          end
        end

        def must_content_with(received_value) # rubocop:disable Metrics/MethodLength
          {
            is: ->(value:) { condition_with(value, received_value) },
            message: lambda do |**attributes|
              message_for(
                **attributes,
                attribute_name: attributes[:input].system_name.to_s.titleize,
                input_name: attributes[:input].name,
                received_value: received_value
              )
            end
          }
        end

        def condition_with(_value, _received_value)
          raise "Need to implement `condition_with(value, received_value)` method"
        end

        def message_for(**)
          raise "Need to implement `message_for(**attributes)` method"
        end
      end
    end
  end
end
