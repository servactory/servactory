# frozen_string_literal: true

module Servactory
  module Context
    module Workspace
      class Actor
        attr_reader :class_name

        def initialize(context)
          @class_name = context.class.name
        end
      end

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

      def success!
        raise self.class.config.success_class.new(context: self)
      end

      def fail_input!(input_name, message:, meta: nil)
        raise self.class.config.input_exception_class.new(
          input_name: input_name,
          message: message,
          meta: meta
        )
      end

      def fail_internal!(internal_name, message:, meta: nil)
        raise self.class.config.internal_exception_class.new(
          internal_name: internal_name,
          message: message,
          meta: meta
        )
      end

      def fail_output!(output_name, message:, meta: nil)
        raise self.class.config.output_exception_class.new(
          output_name: output_name,
          message: message,
          meta: meta
        )
      end

      def fail!(type = :base, message:, meta: nil)
        raise self.class.config.failure_class.new(type: type, message: message, meta: meta)
      end

      def fail_result!(service_result)
        fail!(service_result.error.type, message: service_result.error.message, meta: service_result.error.meta)
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
          type: :base,
          message: I18n.t(
            "servactory.methods.call.not_used",
            service_class_name: servactory_service_info.class_name
          )
        )
      end

      def servactory_service_info
        @servactory_service_info ||= self.class::Actor.new(self)
      end

      def servactory_service_store
        @servactory_service_store ||= Store.new(self)
      end
    end
  end
end
