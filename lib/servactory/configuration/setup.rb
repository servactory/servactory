# frozen_string_literal: true

module Servactory
  module Configuration
    class Setup
      attr_accessor :input_exception_class,
                    :internal_exception_class,
                    :output_exception_class,
                    :success_class,
                    :failure_class,
                    :hash_mode_class_names,
                    :input_option_helpers,
                    :internal_option_helpers,
                    :output_option_helpers,
                    :action_aliases,
                    :action_shortcuts

      def initialize # rubocop:disable Metrics/MethodLength
        @input_exception_class = Servactory::Exceptions::Input
        @internal_exception_class = Servactory::Exceptions::Internal
        @output_exception_class = Servactory::Exceptions::Output

        @success_class = Servactory::Exceptions::Success
        @failure_class = Servactory::Exceptions::Failure

        @hash_mode_class_names =
          Servactory::Maintenance::HashMode::ClassNamesCollection.new(default_hash_mode_class_names)

        @input_option_helpers =
          Servactory::Maintenance::Attributes::OptionHelpersCollection.new(default_input_option_helpers)

        @internal_option_helpers =
          Servactory::Maintenance::Attributes::OptionHelpersCollection.new

        @output_option_helpers =
          Servactory::Maintenance::Attributes::OptionHelpersCollection.new

        @action_aliases = Servactory::Actions::Aliases::Collection.new
        @action_shortcuts = Servactory::Actions::Shortcuts::Collection.new
      end

      private

      def default_hash_mode_class_names
        Set[Hash]
      end

      def default_input_option_helpers
        Set[
          Servactory::Maintenance::Attributes::OptionHelper.new(name: :optional, equivalent: { required: false }),
        ]
      end
    end
  end
end
