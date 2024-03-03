# frozen_string_literal: true

module Servactory
  module Context
    class Store
      def initialize(context)
        @context = context
      end

      def outputs
        state.fetch(:outputs)
      end

      def fetch_internal(key)
        state.fetch(:internals).fetch(key, nil)
      end

      def assign_internal(key, value)
        state[:internals].merge!({ key => value })
      end

      def fetch_output(key)
        outputs.fetch(key, nil)
      end

      def assign_output(key, value)
        state[:outputs].merge!({ key => value })
      end

      private

      def state
        @state ||= {
          internals: {},
          outputs: {}
        }
      end
    end
  end
end
