# frozen_string_literal: true

module Servactory
  module Configuration
    class Factory
      def input_error_class(input_error_class)
        Servactory.configuration.input_error_class = input_error_class
      end

      def output_error_class(output_error_class)
        Servactory.configuration.output_error_class = output_error_class
      end

      def internal_error_class(internal_error_class)
        Servactory.configuration.internal_error_class = internal_error_class
      end

      def failure_class(failure_class)
        Servactory.configuration.failure_class = failure_class
      end

      def method_shortcuts(method_shortcuts)
        Servactory.configuration.method_shortcuts.merge(method_shortcuts)
      end
    end
  end
end
