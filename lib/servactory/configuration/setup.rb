# frozen_string_literal: true

module Servactory
  module Configuration
    class Setup
      attr_accessor :input_attribute_error_class,
                    :internal_attribute_error_class,
                    :output_attribute_error_class,
                    :failure_class

      def initialize
        @input_attribute_error_class = Servactory::Errors::InputError
        @internal_attribute_error_class = Servactory::Errors::InternalError
        @output_attribute_error_class = Servactory::Errors::OutputError

        @failure_class = Servactory::Errors::Failure
      end
    end
  end
end
