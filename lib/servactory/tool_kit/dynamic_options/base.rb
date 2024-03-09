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
            option_value = (data.is_a?(Hash) && data.key?(:is) ? data[:is] : data)

            {
              must: {
                name => must_content_with(option_value)
              }
            }
          end
        end

        def must_content_with(option_value)
          {
            is: must_content_value_with(option_value: option_value),
            message: must_content_message_with(option_value: option_value)
          }
        end

        ########################################################################

        def must_content_value_with(option_value:)
          lambda do |value:, input: nil, internal: nil, output: nil|
            if input.present? && input.input?
              condition_for_input_with(input: input, value: value, option_value: option_value)
            elsif internal.present? && internal.internal?
              condition_for_internal_with(internal: internal, value: value, option_value: option_value)
            elsif output.present? && output.output?
              condition_for_output_with(output: output, value: value, option_value: option_value)
            end
          end
        end

        def must_content_message_with(option_value:) # rubocop:disable Metrics/MethodLength
          lambda do |input: nil, internal: nil, output: nil, **attributes|
            if input.present? && input.input?
              message_for_input_with(
                **attributes,
                input: input,
                option_value: option_value
              )
            elsif internal.present? && internal.internal?
              message_for_internal_with(
                **attributes,
                internal: internal,
                option_value: option_value
              )
            elsif output.present? && output.output?
              message_for_output_with(
                **attributes,
                output: output,
                option_value: option_value
              )
            end
          end
        end

        ########################################################################

        def condition_for_input_with(**)
          raise "Need to implement `condition_for_input_with(**attributes)` method"
        end

        def condition_for_internal_with(**)
          raise "Need to implement `condition_for_internal_with(**attributes)` method"
        end

        def condition_for_output_with(**)
          raise "Need to implement `condition_for_output_with(**attributes)` method"
        end

        def message_for_input_with(**)
          raise "Need to implement `message_for_input_with(**attributes)` method"
        end

        def message_for_internal_with(**)
          raise "Need to implement `message_for_internal_with(**attributes)` method"
        end

        def message_for_output_with(**)
          raise "Need to implement `message_for_output_with(**attributes)` method"
        end
      end
    end
  end
end
