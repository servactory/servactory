# frozen_string_literal: true

module Servactory
  module Context
    module Workspace
      def errors
        @errors ||= Servactory::Errors::Collection.new
      end

      def assign_inputs(inputs)
        @inputs = inputs
      end

      def raise_first_fail
        return if (tmp_errors = errors.for_fails.not_blank).empty?

        raise tmp_errors.first
      end

      protected

      attr_reader :inputs

      def fail_input!(input_name, message:)
        raise Servactory.configuration.input_error_class.new(
          input_name: input_name,
          message: message
        )
      end

      def fail!(message:, meta: nil)
        errors << Servactory.configuration.failure_class.new(message: message, meta: meta)
      end
    end
  end
end
