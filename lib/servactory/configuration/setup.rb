# frozen_string_literal: true

module Servactory
  module Configuration
    class Setup
      attr_accessor :input_exception_class,
                    :internal_exception_class,
                    :output_exception_class,
                    :success_class,
                    :failure_class,
                    :result_class,
                    :collection_mode_class_names,
                    :hash_mode_class_names,
                    :input_option_helpers,
                    :internal_option_helpers,
                    :output_option_helpers,
                    :action_aliases,
                    :action_shortcuts,
                    :action_rescue_handlers,
                    :i18n_root_key,
                    :predicate_methods_enabled

      def initialize # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
        @input_exception_class = Servactory::Exceptions::Input
        @internal_exception_class = Servactory::Exceptions::Internal
        @output_exception_class = Servactory::Exceptions::Output

        @success_class = Servactory::Exceptions::Success
        @failure_class = Servactory::Exceptions::Failure

        @result_class = Servactory::Result

        @collection_mode_class_names =
          Servactory::Configuration::ClassNamesCollection.new(default_collection_mode_class_names)

        @hash_mode_class_names =
          Servactory::Maintenance::HashMode::ClassNamesCollection.new(default_hash_mode_class_names)

        @input_option_helpers =
          Servactory::Maintenance::Attributes::OptionHelpersCollection.new(default_input_option_helpers)

        @internal_option_helpers =
          Servactory::Maintenance::Attributes::OptionHelpersCollection.new(default_internal_option_helpers)

        @output_option_helpers =
          Servactory::Maintenance::Attributes::OptionHelpersCollection.new(default_output_option_helpers)

        @action_aliases = Servactory::Actions::Aliases::Collection.new
        @action_shortcuts = Servactory::Actions::Shortcuts::Collection.new
        @action_rescue_handlers = Servactory::Actions::RescueHandlers::Collection.new

        @i18n_root_key = "servactory"

        @predicate_methods_enabled = true
      end

      def predicate_methods_enabled?
        @predicate_methods_enabled
      end

      private

      def default_collection_mode_class_names
        Set[Array, Set]
      end

      def default_hash_mode_class_names
        Set[Hash]
      end

      def default_input_option_helpers
        Set[
          Servactory::Maintenance::Attributes::OptionHelper.new(name: :optional, equivalent: { required: false }),
          Servactory::ToolKit::DynamicOptions::ConsistsOf.use(collection_mode_class_names:)
        ]
      end

      def default_internal_option_helpers
        Set[
          Servactory::ToolKit::DynamicOptions::ConsistsOf.use(collection_mode_class_names:)
        ]
      end

      def default_output_option_helpers
        Set[
          Servactory::ToolKit::DynamicOptions::ConsistsOf.use(collection_mode_class_names:)
        ]
      end
    end
  end
end
