# frozen_string_literal: true

module Servactory
  module Context
    module Workspace
      attr_reader :inputs

      def errors
        @errors ||= Errors.new
      end

      def assign_inputs(inputs)
        @inputs = inputs
      end

      def fail_input!(input_attribute_name, message)
        raise Servactory.configuration.input_argument_error_class, Error.new(input_attribute_name, message).message
      end

      def fail!(error)
        errors << Error.new(:_fail, error)
      end

      def raise_first_error
        return if (tmp_errors = errors.for_fails.not_blank_and_uniq).empty?

        raise Servactory.configuration.failure_class, tmp_errors.first.message
      end
    end
  end
end
