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
            option_message = (data.is_a?(Hash) && data.key?(:message) ? data[:message] : nil)

            {
              must: {
                name => must_content_with(option_value, option_message)
              }
            }
          end
        end

        def must_content_with(option_value, option_message)
          {
            is: must_content_value_with(option_value: option_value),
            message: must_content_message_with(option_value: option_value, option_message: option_message)
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

        # rubocop:disable Metrics/MethodLength, Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
        def must_content_message_with(option_value:, option_message:)
          is_option_message_present = option_message.present?

          lambda do |input: nil, internal: nil, output: nil, **attributes|
            default_attributes = { **attributes, option_value: option_value }

            if input.present? && input.input?
              if is_option_message_present
                option_message.call(**default_attributes.merge(input: input))
              else
                message_for_input_with(**default_attributes.merge(input: input))
              end
            elsif internal.present? && internal.internal?
              if is_option_message_present
                option_message.call(**default_attributes.merge(internal: internal))
              else
                message_for_internal_with(**default_attributes.merge(internal: internal))
              end
            elsif output.present? && output.output?
              if is_option_message_present
                option_message.call(**default_attributes.merge(output: output))
              else
                message_for_output_with(**default_attributes.merge(output: output))
              end
            end
          end
        end
        # rubocop:enable Metrics/MethodLength, Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

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
