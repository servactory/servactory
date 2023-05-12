# frozen_string_literal: true

module Servactory
  module Configuration
    class Factory
      def input_argument_error_class(input_argument_error_class)
        Servactory.configuration.input_argument_error_class = input_argument_error_class
      end

      def output_argument_error_class(output_argument_error_class)
        Servactory.configuration.output_argument_error_class = output_argument_error_class
      end

      def internal_argument_error_class(internal_argument_error_class)
        Servactory.configuration.internal_argument_error_class = internal_argument_error_class
      end

      def failure_class(failure_class)
        Servactory.configuration.failure_class = failure_class
      end
    end
  end
end
