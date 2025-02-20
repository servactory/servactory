# frozen_string_literal: true

module Servactory
  module Info
    class Builder
      attr_reader :inputs,
                  :internals,
                  :outputs

      def self.build(...)
        new.build(...)
      end

      def build(collection_of_inputs:, collection_of_internals:, collection_of_outputs:, config:)
        dynamic_options = config.input_option_helpers.dynamic_options

        build_inputs_with(collection_of_inputs:, dynamic_options:)
        build_internals_with(collection_of_internals:, dynamic_options:)
        build_outputs_with(collection_of_outputs:, dynamic_options:)

        self
      end

      private

      def build_inputs_with(collection_of_inputs:, dynamic_options:)
        @inputs = collection_of_inputs.to_h do |input|
          options = build_options_for(input, dynamic_options)
          options = enrich_options_for(input, options)

          options[:required] = input.required
          options[:default] = input.default

          [
            input.name,
            options
          ]
        end
      end

      def build_internals_with(collection_of_internals:, dynamic_options:)
        @internals = collection_of_internals.to_h do |internal|
          options = build_options_for(internal, dynamic_options)
          options = enrich_options_for(internal, options)

          [
            internal.name,
            options
          ]
        end
      end

      def build_outputs_with(collection_of_outputs:, dynamic_options:)
        @outputs = collection_of_outputs.to_h do |output|
          options = build_options_for(output, dynamic_options)
          options = enrich_options_for(output, options)

          [
            output.name,
            options
          ]
        end
      end

      ##########################################################################

      def build_options_for(attribute, dynamic_options)
        attribute.options.to_h do |key, value|
          dynamic_option = dynamic_options.find_by(name: key)

          next [nil, nil] if dynamic_option.nil?

          body_key = dynamic_option.meta.fetch(:body_key)

          option = build_option_from(body_key:, value:)

          [
            dynamic_option.name,
            option
          ]
        end.compact
      end

      def build_option_from(body_key:, value:)
        {
          body_key => value.is_a?(Hash) ? value.fetch(body_key, value) : value,
          message: value.is_a?(Hash) ? value.fetch(:message, nil) : nil
        }
      end

      def enrich_options_for(attribute, options)
        actor = attribute.class::Actor.new(attribute)
        must = attribute.collection_of_options.find_by(name: :must)

        options.merge(
          actor:,
          types: attribute.types,
          must: must.body
        )
      end
    end
  end
end
