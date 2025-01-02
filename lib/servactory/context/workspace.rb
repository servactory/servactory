# frozen_string_literal: true

module Servactory
  module Context
    module Workspace
      class Actor
        attr_reader :class_name

        def initialize(context)
          @class_name = context.class.name
          @i18n_root_key = context.class.config.i18n_root_key
        end

        def translate(key, **options)
          I18n.t(
            "#{@i18n_root_key}.#{key}",
            service_class_name: class_name,
            **options
          )
        end
      end

      def inputs
        @inputs ||= Inputs.new(
          context: self,
          collection_of_inputs:
        )
      end

      def internals
        @internals ||= Internals.new(
          context: self,
          collection_of_internals:
        )
      end

      def outputs
        @outputs ||= Outputs.new(
          context: self,
          collection_of_outputs:
        )
      end

      def success!
        raise self.class.config.success_class.new(context: self)
      end

      def fail_input!(input_name, message:, meta: nil)
        raise self.class.config.input_exception_class.new(
          context: self,
          input_name:,
          message:,
          meta:
        )
      end

      def fail_internal!(internal_name, message:, meta: nil)
        raise self.class.config.internal_exception_class.new(
          context: self,
          internal_name:,
          message:,
          meta:
        )
      end

      def fail_output!(output_name, message:, meta: nil)
        raise self.class.config.output_exception_class.new(
          context: self,
          output_name:,
          message:,
          meta:
        )
      end

      def fail!(type = :base, message:, meta: nil)
        raise self.class.config.failure_class.new(type:, message:, meta:)
      end

      def fail_result!(service_result)
        fail!(service_result.error.type, message: service_result.error.message, meta: service_result.error.meta)
      end

      private

      attr_reader :collection_of_inputs,
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
          incoming_arguments:,
          collection_of_inputs:,
          collection_of_internals:,
          collection_of_outputs:,
          collection_of_stages:
        )
      end

      def call!(
        collection_of_inputs:,
        collection_of_internals:,
        collection_of_outputs:,
        **
      )
        @collection_of_inputs = collection_of_inputs
        @collection_of_internals = collection_of_internals
        @collection_of_outputs = collection_of_outputs
      end

      def call
        raise self.class.config.failure_class.new(
          type: :base,
          message: servactory_service_info.translate(
            "methods.call.not_used"
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
