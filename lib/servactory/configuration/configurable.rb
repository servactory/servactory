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
          Config.new.tap do |c|
            c.collection_mode_class_names = CollectionMode::ClassNamesCollection.new(default_collection_mode_class_names)
            c.hash_mode_class_names = HashMode::ClassNamesCollection.new(default_hash_mode_class_names)

            c.input_exception_class = Servactory::Exceptions::Input
            c.internal_exception_class = Servactory::Exceptions::Internal
            c.output_exception_class = Servactory::Exceptions::Output

            c.failure_class = Servactory::Exceptions::Failure
            c.success_class = Servactory::Exceptions::Success

            c.result_class = Servactory::Result

            c.i18n_root_key = "servactory"
            c.predicate_methods_enabled = true

            c.input_option_helpers = OptionHelpers::OptionHelpersCollection.new(default_input_option_helpers(c))
            c.internal_option_helpers = OptionHelpers::OptionHelpersCollection.new(default_internal_option_helpers(c))
            c.output_option_helpers = OptionHelpers::OptionHelpersCollection.new(default_output_option_helpers(c))

            c.action_aliases = Actions::Aliases::Collection.new
            c.action_shortcuts = Actions::Shortcuts::Collection.new
            c.action_rescue_handlers = Actions::RescueHandlers::Collection.new
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
            Servactory::Maintenance::Attributes::OptionHelper.new(name: :optional, equivalent: { required: false }),
            Servactory::ToolKit::DynamicOptions::ConsistsOf.use(collection_mode_class_names: config.collection_mode_class_names),
            Servactory::ToolKit::DynamicOptions::Schema.use(default_hash_mode_class_names:),
            Servactory::ToolKit::DynamicOptions::Inclusion.use
          ]
        end

        def default_internal_option_helpers(config)
          Set[
            Servactory::ToolKit::DynamicOptions::ConsistsOf.use(collection_mode_class_names: config.collection_mode_class_names),
            Servactory::ToolKit::DynamicOptions::Schema.use(default_hash_mode_class_names:),
            Servactory::ToolKit::DynamicOptions::Inclusion.use
          ]
        end

        def default_output_option_helpers(config)
          Set[
            Servactory::ToolKit::DynamicOptions::ConsistsOf.use(collection_mode_class_names: config.collection_mode_class_names),
            Servactory::ToolKit::DynamicOptions::Schema.use(default_hash_mode_class_names:),
            Servactory::ToolKit::DynamicOptions::Inclusion.use
          ]
        end
      end
    end
  end
end
