# frozen_string_literal: true

module Servactory
  module ToolKit
    module DynamicOptions
      class Must
        class WorkOption
          attr_reader :value,
                      :message,
                      :properties

          def initialize(value:, message:, properties:)
            @value = value
            @message = message
            @properties = properties
          end
        end

        def initialize(option_name)
          @option_name = option_name
        end

        def must(name)
          Servactory::Maintenance::Attributes::OptionHelper.new(
            name: @option_name,
            equivalent: equivalent_with(name)
          )
        end

        def equivalent_with(name) # rubocop:disable Metrics/MethodLength
          lambda do |data|
            option_value = (data.is_a?(Hash) && data.key?(:is) ? data.delete(:is) : data)
            option_message = (data.is_a?(Hash) && data.key?(:message) ? data.delete(:message) : nil)
            option_properties = data.is_a?(Hash) ? data : {}

            option = WorkOption.new(
              value: option_value,
              message: option_message,
              properties: option_properties
            )

            {
              must: {
                name => must_content_with(option)
              }
            }
          end
        end

        def must_content_with(option)
          {
            is: must_content_value_with(option),
            message: must_content_message_with(option)
          }
        end

        ########################################################################

        def must_content_value_with(option)
          lambda do |value:, input: nil, internal: nil, output: nil|
            if input.present? && input.input?
              condition_for_input_with(input: input, value: value, option: option)
            elsif internal.present? && internal.internal?
              condition_for_internal_with(internal: internal, value: value, option: option)
            elsif output.present? && output.output?
              condition_for_output_with(output: output, value: value, option: option)
            end
          end
        end

        # rubocop:disable Metrics/MethodLength, Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
        def must_content_message_with(option)
          is_option_message_present = option.message.present?
          is_option_message_proc = option.message.is_a?(Proc) if is_option_message_present

          lambda do |input: nil, internal: nil, output: nil, **attributes|
            default_attributes = { **attributes, option_value: option.value }

            if Servactory::Utils.really_input?(input)
              if is_option_message_present
                is_option_message_proc ? option.message.call(**default_attributes.merge(input: input)) : option.message
              else
                message_for_input_with(**default_attributes.merge(input: input))
              end
            elsif Servactory::Utils.really_internal?(internal)
              if is_option_message_present
                is_option_message_proc ? option.message.call(**default_attributes.merge(internal: internal)) : option.message # rubocop:disable Layout/LineLength
              else
                message_for_internal_with(**default_attributes.merge(internal: internal))
              end
            elsif Servactory::Utils.really_output?(output)
              if is_option_message_present
                is_option_message_proc ? option.message.call(**default_attributes.merge(output: output)) : option.message # rubocop:disable Layout/LineLength
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
