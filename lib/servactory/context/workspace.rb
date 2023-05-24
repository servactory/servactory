# frozen_string_literal: true

module Servactory
  module Context
    module Workspace
      attr_reader :inputs

      def errors
        @errors ||= Servactory::Errors::Collection.new
      end

      def assign_inputs(inputs)
        @inputs = inputs
      end

      def fail_input!(input_attribute_name, message:)
        raise Servactory.configuration.input_error_class.new(
          input_name: input_attribute_name,
          message: message
        )
      end

      def fail!(message:, meta: nil)
        errors << Servactory.configuration.failure_class.new(message: message, meta: meta)
      end

      def raise_first_fail
        return if (tmp_errors = errors.for_fails.not_blank).empty?

        raise tmp_errors.first
      end
    end
  end
end
