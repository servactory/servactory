# frozen_string_literal: true

module ServiceFactory
  class Configuration
    attr_accessor :input_argument_error_class,
                  :internal_argument_error_class,
                  :output_argument_error_class,
                  :failure_class

    def initialize
      @input_argument_error_class = ServiceFactory::Errors::InputArgumentError
      @internal_argument_error_class = ServiceFactory::Errors::InternalArgumentError
      @output_argument_error_class = ServiceFactory::Errors::OutputArgumentError

      @failure_class = ServiceFactory::Errors::Failure
    end
  end
end
