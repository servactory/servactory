# frozen_string_literal: true

module Servactory
  module Context
    module Workspace
      def inputs
        @inputs ||= Inputs.new(self, workbench: self.class.send(:inputs_workbench))
      end
      alias inp inputs

      def internals
        @internals ||= Internals.new(self, workbench: self.class.send(:internals_workbench))
      end
      alias int internals

      def outputs
        @outputs ||= Outputs.new(self, workbench: self.class.send(:outputs_workbench))
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
    end
  end
end
