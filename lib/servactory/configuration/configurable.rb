# frozen_string_literal: true

module Servactory
  module Configuration
    module Configurable
      extend ActiveSupport::Concern

      included do # rubocop:disable Metrics/BlockLength
        include ActiveSupport::Configurable

        config_accessor(:collection_mode_class_names, instance_accessor: false) do
          Servactory::Configuration::CollectionMode::ClassNamesCollection
            .new(default_collection_mode_class_names)
        end

        config_accessor(:hash_mode_class_names, instance_accessor: false) do
          Servactory::Configuration::HashMode::ClassNamesCollection
            .new(default_hash_mode_class_names)
        end

        ########################################################################

        config_accessor(:input_exception_class, instance_accessor: false) do
          Servactory::Exceptions::Input
        end
        config_accessor(:internal_exception_class, instance_accessor: false) do
          Servactory::Exceptions::Internal
        end
        config_accessor(:output_exception_class, instance_accessor: false) do
          Servactory::Exceptions::Output
        end

        config_accessor(:failure_class, instance_accessor: false) do
          Servactory::Exceptions::Failure
        end
        config_accessor(:success_class, instance_accessor: false) do
          Servactory::Exceptions::Success
        end

        config_accessor(:result_class, instance_accessor: false) do
          Servactory::Result
        end

        config_accessor(:i18n_root_key, instance_accessor: false) do
          "servactory"
        end

        config_accessor(:predicate_methods_enabled, instance_accessor: false) do
          true
        end

        config_accessor(:input_option_helpers, instance_accessor: false) do
          Servactory::Configuration::OptionHelpers::OptionHelpersCollection
            .new(default_input_option_helpers)
        end

        config_accessor(:internal_option_helpers, instance_accessor: false) do
          Servactory::Configuration::OptionHelpers::OptionHelpersCollection
            .new(default_internal_option_helpers)
        end

        config_accessor(:output_option_helpers, instance_accessor: false) do
          Servactory::Configuration::OptionHelpers::OptionHelpersCollection
            .new(default_output_option_helpers)
        end

        config_accessor(:action_aliases, instance_accessor: false) do
          Servactory::Configuration::Actions::Aliases::Collection.new
        end

        config_accessor(:action_shortcuts, instance_accessor: false) do
          Servactory::Configuration::Actions::Shortcuts::Collection.new
        end

        config_accessor(:action_rescue_handlers, instance_accessor: false) do
          Servactory::Configuration::Actions::RescueHandlers::Collection.new
        end
      end

      class_methods do # rubocop:disable Metrics/BlockLength
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
            Servactory::ToolKit::DynamicOptions::ConsistsOf.use(collection_mode_class_names:),
            Servactory::ToolKit::DynamicOptions::Schema.use(default_hash_mode_class_names:),
            Servactory::ToolKit::DynamicOptions::Inclusion.use
          ]
        end

        def default_internal_option_helpers
          Set[
            Servactory::ToolKit::DynamicOptions::ConsistsOf.use(collection_mode_class_names:),
            Servactory::ToolKit::DynamicOptions::Schema.use(default_hash_mode_class_names:),
            Servactory::ToolKit::DynamicOptions::Inclusion.use
          ]
        end

        def default_output_option_helpers
          Set[
            Servactory::ToolKit::DynamicOptions::ConsistsOf.use(collection_mode_class_names:),
            Servactory::ToolKit::DynamicOptions::Schema.use(default_hash_mode_class_names:),
            Servactory::ToolKit::DynamicOptions::Inclusion.use
          ]
        end
      end
    end
  end
end
