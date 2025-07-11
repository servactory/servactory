# frozen_string_literal: true

module Servactory
  module Info
    class Builder # rubocop:disable Metrics/ClassLength
      attr_reader :inputs,
                  :internals,
                  :outputs,
                  :stages

      def self.build(...)
        new.build(...)
      end

      def build(collection_of_inputs:, collection_of_internals:, collection_of_outputs:, collection_of_stages:, config:)
        build_all_attributes(
          inputs: collection_of_inputs,
          internals: collection_of_internals,
          outputs: collection_of_outputs,
          stages: collection_of_stages,
          config:
        )

        self
      end

      private

      # rubocop:disable Metrics/MethodLength
      def build_all_attributes(inputs:, internals:, outputs:, stages:, config:)
        build_input_attributes_with(
          collection: inputs,
          dynamic_options: config.input_option_helpers.dynamic_options
        )

        build_internal_attributes_with(
          collection: internals,
          dynamic_options: config.internal_option_helpers.dynamic_options
        )

        build_output_attributes_with(
          collection: outputs,
          dynamic_options: config.output_option_helpers.dynamic_options
        )

        build_action_stages_with(collection: stages)
      end
      # rubocop:enable Metrics/MethodLength

      def build_input_attributes_with(collection:, dynamic_options:)
        @inputs = build_attributes_with(
          collection:,
          dynamic_options:,
          include_specific_options: true
        )
      end

      def build_internal_attributes_with(collection:, dynamic_options:)
        @internals = build_attributes_with(
          collection:,
          dynamic_options:
        )
      end

      def build_output_attributes_with(collection:, dynamic_options:)
        @outputs = build_attributes_with(
          collection:,
          dynamic_options:
        )
      end

      def build_action_stages_with(collection:) # rubocop:disable Metrics/MethodLength
        @stages = collection.to_h do |stage|
          [
            :"stage_#{stage.position}",
            stage.actions.to_h do |action|
              [
                action.name,
                {
                  position: action.position,
                  condition: action.condition
                }
              ]
            end
          ]
        end
      end

      def build_attributes_with(collection:, dynamic_options:, include_specific_options: false) # rubocop:disable Metrics/MethodLength
        collection.to_h do |attribute|
          options = process_options_for(
            attribute:,
            dynamic_options:
          )

          if include_specific_options
            options[:required] = attribute.required
            options[:default] = attribute.default
          end

          [attribute.name, options]
        end
      end

      def process_options_for(attribute:, dynamic_options:)
        options = build_dynamic_options_for(
          attribute:,
          dynamic_options:
        )

        enrich_options_with_common_fields(
          attribute:,
          options:
        )
      end

      def build_dynamic_options_for(attribute:, dynamic_options:)
        attribute.options.to_h do |key, value|
          dynamic_option = dynamic_options.find_by(name: key)
          next [nil, nil] if dynamic_option.nil?

          body_key = dynamic_option.meta.fetch(:body_key)
          option = format_option_value(body_key:, value:)

          [dynamic_option.name, option]
        end.compact
      end

      def format_option_value(body_key:, value:)
        {
          body_key => extract_value_for_body_key(body_key:, value:),
          message: extract_message_from_value(value:)
        }
      end

      def extract_value_for_body_key(body_key:, value:)
        value.is_a?(Hash) ? value.fetch(body_key, value) : value
      end

      def extract_message_from_value(value:)
        value.is_a?(Hash) ? value.fetch(:message, nil) : nil
      end

      def enrich_options_with_common_fields(attribute:, options:)
        actor = attribute.class::Actor.new(attribute)
        must = attribute.collection_of_options.find_by(name: :must)

        options.merge(
          actor:,
          types: attribute.types,
          must: must&.body
        )
      end
    end
  end
end
