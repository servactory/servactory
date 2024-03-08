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

        # rubocop:disable Metrics/MethodLength, Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
        def must_content_with(received_value)
          {
            is: lambda do |value:, input: nil, internal: nil, output: nil|
              if input.present? && input.input?
                condition_for_input_with(input: input, value: value, received_value: received_value)
              elsif internal.present? && internal.internal?
                condition_for_internal_with(internal: internal, value: value, received_value: received_value)
              elsif output.present? && output.output?
                condition_for_output_with(output: output, value: value, received_value: received_value)
              end
            end,
            message: lambda do |input: nil, internal: nil, output: nil, **attributes|
              if input.present? && input.input?
                message_for_input_with(
                  **attributes,
                  input_name: input.name,
                  received_value: received_value
                )
              elsif internal.present? && internal.internal?
                message_for_internal_with(
                  **attributes,
                  internal_name: internal.name,
                  received_value: received_value
                )
              elsif output.present? && output.output?
                message_for_output_with(
                  **attributes,
                  output_name: output.name,
                  received_value: received_value
                )
              end
            end
          }
        end
        # rubocop:enable Metrics/MethodLength, Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

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
