# frozen_string_literal: true

module Servactory
  module Context
    module Workspace
      def inputs
        @inputs ||= Inputs.new(
          self,
          collection_of_inputs: self.class.send(:collection_of_inputs),
          incoming_arguments: @incoming_arguments
        )
      end
      alias inp inputs

      def internals
        @internals ||= Internals.new(self, collection_of_internals: self.class.send(:collection_of_internals))
      end
      alias int internals

      def outputs
        @outputs ||= Outputs.new(self, collection_of_outputs: self.class.send(:collection_of_outputs))
      end
      alias out outputs

      def fail_input!(input_name, message:)
        raise Servactory.configuration.input_error_class.new(
          input_name: input_name,
          message: message
        )
      end

      def fail!(message:, meta: nil)
        raise Servactory.configuration.failure_class.new(message: message, meta: meta)
      end

      private

      def _call!(
        incoming_arguments:,
        collection_of_inputs:,
        collection_of_internals:,
        collection_of_outputs:,
        collection_of_stages:
      )
        call!(
          incoming_arguments: incoming_arguments,
          collection_of_inputs: collection_of_inputs,
          collection_of_internals: collection_of_internals,
          collection_of_outputs: collection_of_outputs,
          collection_of_stages: collection_of_stages
        )
      end

      def call!(incoming_arguments:, **)
        @incoming_arguments = incoming_arguments
      end

      def service_storage
        @service_storage ||= { internals: {}, outputs: {} }
      end

      def assign_internal(key, value)
        service_storage[:internals].merge!({ key => value })
      end

      def fetch_internal(key)
        service_storage.fetch(:internals).fetch(key)
      end

      def assign_output(key, value)
        service_storage[:outputs].merge!({ key => value })
      end

      def fetch_output(key)
        service_storage.fetch(:outputs).fetch(key)
      end
    end
  end
end
