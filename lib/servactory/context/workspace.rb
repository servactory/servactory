# frozen_string_literal: true

module Servactory
  module Context
    module Workspace
      def inputs
        @inputs ||= Inputs.new(
          context: self,
          incoming_arguments: incoming_arguments,
          collection_of_inputs: collection_of_inputs
        )
      end

      def internals
        @internals ||= Internals.new(
          context: self,
          collection_of_internals: collection_of_internals
        )
      end

      def outputs
        @outputs ||= Outputs.new(
          context: self,
          collection_of_outputs: collection_of_outputs
        )
      end

      def fail_input!(input_name, message:)
        raise self.class.config.input_error_class.new(
          input_name: input_name,
          message: message
        )
      end

      def fail_internal!(internal_name, message:)
        raise self.class.config.internal_error_class.new(
          internal_name: internal_name,
          message: message
        )
      end

      def fail!(message:, meta: nil)
        raise self.class.config.failure_class.new(message: message, meta: meta)
      end

      def fail_result!(service_result)
        fail!(message: service_result.error.message, meta: service_result.error.meta)
      end

      private

      attr_reader :incoming_arguments,
                  :collection_of_inputs,
                  :collection_of_internals,
                  :collection_of_outputs

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

      def call!(
        incoming_arguments:,
        collection_of_inputs:,
        collection_of_internals:,
        collection_of_outputs:,
        **
      )
        @incoming_arguments = incoming_arguments
        @collection_of_inputs = collection_of_inputs
        @collection_of_internals = collection_of_internals
        @collection_of_outputs = collection_of_outputs
      end

      def call
        raise self.class.config.failure_class.new(
          message: I18n.t(
            "servactory.methods.call.not_used",
            service_class_name: self.class.name
          )
        )
      end

      def servactory_service_storage
        @servactory_service_storage ||= { internals: {}, outputs: {} }
      end

      def assign_servactory_service_storage_internal(key, value)
        servactory_service_storage[:internals].merge!({ key => value })
      end

      def fetch_servactory_service_storage_internal(key)
        servactory_service_storage.fetch(:internals).fetch(key, nil)
      end

      def assign_servactory_service_storage_output(key, value)
        servactory_service_storage[:outputs].merge!({ key => value })
      end

      def fetch_servactory_service_storage_output(key)
        servactory_service_storage.fetch(:outputs).fetch(key, nil)
      end
    end
  end
end
