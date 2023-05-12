# frozen_string_literal: true

module Servactory
  module Configuration
    class Setup
      attr_accessor :input_argument_error_class,
                    :internal_argument_error_class,
                    :output_argument_error_class,
                    :failure_class

      def initialize
        @input_argument_error_class = Servactory::Errors::InputArgumentError
        @internal_argument_error_class = Servactory::Errors::InternalArgumentError
        @output_argument_error_class = Servactory::Errors::OutputArgumentError

        @failure_class = Servactory::Errors::Failure
      end
    end
  end
end
