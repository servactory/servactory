# frozen_string_literal: true

module Servactory
  module Configuration
    class Setup
      include ActiveSupport::Configurable

      config_accessor :default_collection_mode_class_names, instance_accessor: false do
        Set[Array, Set]
      end

      config_accessor :default_hash_mode_class_names, instance_accessor: false do
        Set[Hash]
      end

      ##########################################################################

      config_accessor(:collection_mode_class_names) do
        Servactory::Configuration::CollectionMode::ClassNamesCollection
          .new(config.default_collection_mode_class_names)
      end

      config_accessor(:hash_mode_class_names) do
        Servactory::Configuration::HashMode::ClassNamesCollection
          .new(config.default_hash_mode_class_names)
      end

      ##########################################################################

      config_accessor :default_input_option_helpers, instance_accessor: false do
        Set[
          Servactory::Maintenance::Attributes::OptionHelper
          .new(name: :optional, equivalent: { required: false }),
          Servactory::ToolKit::DynamicOptions::ConsistsOf
            .use(collection_mode_class_names: config.collection_mode_class_names),
          Servactory::ToolKit::DynamicOptions::Schema
            .use(default_hash_mode_class_names: config.default_hash_mode_class_names),
          Servactory::ToolKit::DynamicOptions::Inclusion.use
        ]
      end

      config_accessor :default_internal_option_helpers, instance_accessor: false do
        Set[
          Servactory::ToolKit::DynamicOptions::ConsistsOf
          .use(collection_mode_class_names: config.collection_mode_class_names),
          Servactory::ToolKit::DynamicOptions::Schema
            .use(default_hash_mode_class_names: config.default_hash_mode_class_names),
          Servactory::ToolKit::DynamicOptions::Inclusion.use
        ]
      end

      config_accessor :default_output_option_helpers, instance_accessor: false do
        Set[
          Servactory::ToolKit::DynamicOptions::ConsistsOf
          .use(collection_mode_class_names: config.collection_mode_class_names),
          Servactory::ToolKit::DynamicOptions::Schema
            .use(default_hash_mode_class_names: config.default_hash_mode_class_names),
          Servactory::ToolKit::DynamicOptions::Inclusion.use
        ]
      end

      ##########################################################################

      config_accessor(:input_exception_class) { Servactory::Exceptions::Input }
      config_accessor(:internal_exception_class) { Servactory::Exceptions::Internal }
      config_accessor(:output_exception_class) { Servactory::Exceptions::Output }

      config_accessor(:failure_class) { Servactory::Exceptions::Failure }
      config_accessor(:success_class) { Servactory::Exceptions::Success }

      config_accessor(:result_class) { Servactory::Result }

      config_accessor(:i18n_root_key) { "servactory" }

      config_accessor(:predicate_methods_enabled) { true }

      config_accessor(:input_option_helpers) do
        Servactory::Configuration::OptionHelpers::OptionHelpersCollection
          .new(config.default_input_option_helpers)
      end

      config_accessor(:internal_option_helpers) do
        Servactory::Configuration::OptionHelpers::OptionHelpersCollection
          .new(config.default_internal_option_helpers)
      end

      config_accessor(:output_option_helpers) do
        Servactory::Configuration::OptionHelpers::OptionHelpersCollection
          .new(config.default_output_option_helpers)
      end

      config_accessor(:action_aliases) do
        Servactory::Configuration::Actions::Aliases::Collection.new
      end

      config_accessor(:action_shortcuts) do
        Servactory::Configuration::Actions::Shortcuts::Collection.new
      end

      config_accessor(:action_rescue_handlers) do
        Servactory::Configuration::Actions::RescueHandlers::Collection.new
      end
    end
  end
end
