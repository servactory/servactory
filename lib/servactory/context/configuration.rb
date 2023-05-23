# frozen_string_literal: true

module Servactory
  module Context
    class Configuration
      def input_attribute_error_class(input_attribute_error_class)
        Servactory.configuration.input_attribute_error_class = input_attribute_error_class
      end

      def output_attribute_error_class(output_attribute_error_class)
        Servactory.configuration.output_attribute_error_class = output_attribute_error_class
      end

      def internal_attribute_error_class(internal_attribute_error_class)
        Servactory.configuration.internal_attribute_error_class = internal_attribute_error_class
      end

      def failure_class(failure_class)
        Servactory.configuration.failure_class = failure_class
      end
    end
  end
end
