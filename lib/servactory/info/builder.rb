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

      def build_inputs_with(collection_of_inputs:, dynamic_options:) # rubocop:disable Metrics/MethodLength
        @inputs = collection_of_inputs.to_h do |input|
          options = build_options_for(input, dynamic_options)

          actor = input.class::Actor.new(input)
          must = input.collection_of_options.find_by(name: :must)

          options.merge!(
            actor:,
            types: input.types,
            required: input.required,
            default: input.default,
            must: must.body
          )

          [
            input.name,
            options
          ]
        end
      end

      def build_internals_with(collection_of_internals:, dynamic_options:) # rubocop:disable Metrics/MethodLength
        @internals = collection_of_internals.to_h do |internal|
          options = build_options_for(internal, dynamic_options)

          actor = internal.class::Actor.new(internal)
          must = internal.collection_of_options.find_by(name: :must)

          options.merge!(
            actor:,
            types: internal.types,
            must: must.body
          )

          [
            internal.name,
            options
          ]
        end
      end

      def build_outputs_with(collection_of_outputs:, dynamic_options:) # rubocop:disable Metrics/MethodLength
        @outputs = collection_of_outputs.to_h do |output|
          options = build_options_for(output, dynamic_options)

          actor = output.class::Actor.new(output)
          must = output.collection_of_options.find_by(name: :must)

          options.merge!(
            actor:,
            types: output.types,
            must: must.body
          )

          [
            output.name,
            options
          ]
        end
      end

      ##########################################################################

      def build_options_for(argument, dynamic_options) # rubocop:disable Metrics/MethodLength
        argument.options.to_h do |key, value|
          dynamic_option = dynamic_options.find_by(name: key)

          next [nil, nil] if dynamic_option.nil?

          body_key = dynamic_option.meta.fetch(:body_key)

          option = {
            body_key => value.is_a?(Hash) ? value.fetch(body_key, value) : value,
            message: value.is_a?(Hash) ? value.fetch(:message, nil) : nil
          }

          [
            dynamic_option.name,
            option
          ]
        end.compact
      end
    end
  end
end
