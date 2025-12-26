# frozen_string_literal: true

module Servactory
  module Configuration
    module Configurable
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def self.extended(base)
          base.instance_variable_set(:@config, base.send(:build_default_config))
        end

        attr_reader :config

        private

        def build_default_config # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
          Config.new.tap do |config|
            config.collection_mode_class_names = CollectionMode::ClassNamesCollection.new(default_collection_mode_class_names)
            config.hash_mode_class_names = HashMode::ClassNamesCollection.new(default_hash_mode_class_names)

            config.input_exception_class = Servactory::Exceptions::Input
            config.internal_exception_class = Servactory::Exceptions::Internal
            config.output_exception_class = Servactory::Exceptions::Output

            config.failure_class = Servactory::Exceptions::Failure
            config.success_class = Servactory::Exceptions::Success

            config.result_class = Servactory::Result

            config.i18n_root_key = "servactory"
            config.predicate_methods_enabled = true

            config.input_option_helpers =
              OptionHelpers::OptionHelpersCollection.new(default_input_option_helpers(config))
            config.internal_option_helpers =
              OptionHelpers::OptionHelpersCollection.new(default_internal_option_helpers(config))
            config.output_option_helpers =
              OptionHelpers::OptionHelpersCollection.new(default_output_option_helpers(config))

            config.action_aliases = Actions::Aliases::Collection.new
            config.action_shortcuts = Actions::Shortcuts::Collection.new
            config.action_rescue_handlers = Actions::RescueHandlers::Collection.new
          end
        end

        def default_collection_mode_class_names
          Set[Array, Set]
        end

        def default_hash_mode_class_names
          Set[Hash]
        end

        def default_input_option_helpers(config)
          Set[
            Servactory::Maintenance::Attributes::OptionHelper
            .new(name: :optional, equivalent: { required: false }),
            Servactory::ToolKit::DynamicOptions::ConsistsOf
              .use(collection_mode_class_names: config.collection_mode_class_names),
            Servactory::ToolKit::DynamicOptions::Schema.use(default_hash_mode_class_names:),
            Servactory::ToolKit::DynamicOptions::Inclusion.use
          ]
        end

        def default_internal_option_helpers(config)
          Set[
            Servactory::ToolKit::DynamicOptions::ConsistsOf
            .use(collection_mode_class_names: config.collection_mode_class_names),
            Servactory::ToolKit::DynamicOptions::Schema.use(default_hash_mode_class_names:),
            Servactory::ToolKit::DynamicOptions::Inclusion.use
          ]
        end

        def default_output_option_helpers(config)
          Set[
            Servactory::ToolKit::DynamicOptions::ConsistsOf
            .use(collection_mode_class_names: config.collection_mode_class_names),
            Servactory::ToolKit::DynamicOptions::Schema.use(default_hash_mode_class_names:),
            Servactory::ToolKit::DynamicOptions::Inclusion.use
          ]
        end
      end
    end
  end
end
