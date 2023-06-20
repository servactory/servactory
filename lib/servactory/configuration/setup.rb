# frozen_string_literal: true

module Servactory
  module Configuration
    class Setup
      attr_accessor :input_error_class,
                    :internal_error_class,
                    :output_error_class,
                    :failure_class,
                    :input_option_helpers,
                    :make_aliases,
                    :method_shortcuts

      def initialize
        @input_error_class = Servactory::Errors::InputError
        @internal_error_class = Servactory::Errors::InternalError
        @output_error_class = Servactory::Errors::OutputError

        @failure_class = Servactory::Errors::Failure

        @input_option_helpers = Servactory::Inputs::OptionHelpersCollection.new(default_input_option_helpers)

        @make_aliases = Servactory::Methods::MakeAliases::Collection.new
        @method_shortcuts = Servactory::Methods::Shortcuts::Collection.new
      end

      private

      def default_input_option_helpers
        Set[
          Servactory::Inputs::OptionHelper.new(name: :optional, equivalent: { required: false }),
          Servactory::Inputs::OptionHelper.new(name: :as_array, equivalent: { array: true })
        ]
      end
    end
  end
end
