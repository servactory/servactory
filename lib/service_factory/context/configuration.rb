# frozen_string_literal: true

module ServiceFactory
  module Context
    class Configuration
      def input_argument_error_class(input_argument_error_class)
        ServiceFactory.configuration.input_argument_error_class = input_argument_error_class
      end

      def output_argument_error_class(output_argument_error_class)
        ServiceFactory.configuration.output_argument_error_class = output_argument_error_class
      end

      def internal_argument_error_class(internal_argument_error_class)
        ServiceFactory.configuration.internal_argument_error_class = internal_argument_error_class
      end

      def failure_class(failure_class)
        ServiceFactory.configuration.failure_class = failure_class
      end
    end
  end
end
