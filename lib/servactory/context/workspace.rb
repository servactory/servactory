# frozen_string_literal: true

module Servactory
  module Context
    module Workspace
      def inputs
        @inputs ||= Inputs.new(self, workbench: self.class.send(:inputs_workbench))
      end
      alias in inputs

      def internals
        @internals ||= Internals.new(self, collection_of_internals: self.class.send(:collection_of_internals))
      end
      alias int internals

      def outputs
        @outputs ||= Outputs.new(self, collection_of_outputs: self.class.send(:collection_of_outputs))
      end
      alias out outputs

      def errors
        @errors ||= Servactory::Errors::Collection.new
      end

      # def assign_inputs(inputs)
      #   @inputs = inputs
      # end

      def raise_first_fail
        return if (tmp_errors = errors.for_fails.not_blank).empty?

        raise tmp_errors.first
      end

      protected

      def fail_input!(input_name, message:)
        raise Servactory.configuration.input_error_class.new(
          input_name: input_name,
          message: message
        )
      end

      def fail!(
        message:,
        failure_class: Servactory.configuration.failure_class,
        meta: nil
      )
        failure = failure_class.new(message: message, meta: meta)

        raise failure if @service_strict_mode

        errors << failure
      end

      private

      def assign_service_strict_mode(flag)
        @service_strict_mode = flag
      end
    end
  end
end
