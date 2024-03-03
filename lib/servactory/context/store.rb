# frozen_string_literal: true

module Servactory
  module Context
    class Store
      def initialize(context)
        @context = context
      end

      def outputs
        @outputs ||= context_data.fetch(:outputs)
      end

      def fetch_internal(key)
        internals.fetch(key, nil)
      end

      def assign_internal(key, value)
        context_data[:internals].merge!({ key => value })
      end

      def fetch_output(key)
        outputs.fetch(key, nil)
      end

      def assign_output(key, value)
        context_data[:outputs].merge!({ key => value })
      end

      private

      def internals
        @internals ||= context_data.fetch(:internals)
      end

      def context_data
        @context_data ||= state.fetch(context_id)
      end

      def state
        {
          context_id => {
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
