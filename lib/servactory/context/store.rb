# frozen_string_literal: true

module Servactory
  module Context
    class Store
      def initialize(context)
        @context = context
      end

      def assign_inputs(arguments)
        context_data[:inputs].merge!(arguments)
      end

      def fetch_input(name)
        inputs.fetch(name, nil)
      end

      def assign_internal(name, value)
        # assign_attribute(:internals, name, value)

        @context.instance_variable_set(:"@_servactory_internal_#{name}", value)
      end

      def fetch_internal(name)
        # internals.fetch(name, nil)

        @context.instance_variable_get(:"@_servactory_internal_#{name}")
      end

      def assign_output(name, value)
        # assign_attribute(:outputs, name, value)

        @context.instance_variable_set(:"@_servactory_output_#{name}", value)
      end

      def fetch_output(name)
        # outputs.fetch(name, nil)

        @context.instance_variable_get(:"@_servactory_output_#{name}")
      end

      def inputs
        @inputs ||= context_data.fetch(:inputs)
      end

      def internals
        @internals ||= context_data.fetch(:internals)
      end

      def outputs
        @outputs ||= context_data.fetch(:outputs)
      end

      private

      def assign_attribute(section, name, value)
        context_data[section].merge!({ name => value })
      end

      def context_data
        @context_data ||= state.fetch(context_id)
      end

      def state
        {
          context_id => {
            inputs: {},
            internals: {},
            outputs: {}
          }
        }
      end

      def context_id
        @context_id ||= "context_#{@context.object_id}"
      end
    end
  end
end
