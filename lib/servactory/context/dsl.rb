# frozen_string_literal: true

module Servactory
  module Context
    module DSL
      def self.included(base)
        base.extend(Callable)
        base.include(Workspace)
      end

      def _call!(arguments, collection_of_inputs)
        call!(arguments, collection_of_inputs)
      end

      def storage
        puts "storage: self #{self}"

        @storage ||= {
          internals: {},
          outputs: {}
        }
      end

      def assign_internal(key, value)
        storage[:internals].merge!({ key => value })
      end

      def fetch_internal(key)
        storage.fetch(:internals).fetch(key)
      end

      def assign_output(key, value)
        storage[:outputs].merge!({ key => value })
      end

      def fetch_output(key)
        storage.fetch(:outputs).fetch(key)
      end
    end
  end
end
