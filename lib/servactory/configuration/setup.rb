# frozen_string_literal: true

module Servactory
  module Configuration
    class Setup
      attr_accessor :input_error_class,
                    :internal_error_class,
                    :output_error_class,
                    :failure_class,
                    :method_shortcuts

      def initialize
        @input_error_class = Servactory::Errors::InputError
        @internal_error_class = Servactory::Errors::InternalError
        @output_error_class = Servactory::Errors::OutputError

        @failure_class = Servactory::Errors::Failure

        @method_shortcuts = Servactory::Methods::Shortcuts::Collection.new
      end
    end
  end
end
