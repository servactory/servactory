# frozen_string_literal: true

module Servactory
  module Configuration
    class Config
      attr_accessor :input_exception_class,
                    :internal_exception_class,
                    :output_exception_class,
                    :failure_class,
                    :success_class,
                    :result_class,
                    :action_shortcuts,
                    :action_aliases,
                    :input_option_helpers,
                    :internal_option_helpers,
                    :output_option_helpers,
                    :collection_mode_class_names,
                    :hash_mode_class_names,
                    :action_rescue_handlers,
                    :i18n_root_key,
                    :predicate_methods_enabled

      def initialize_dup(original) # rubocop:disable Metrics/AbcSize
        super
        @action_shortcuts = original.action_shortcuts.dup
        @action_aliases = original.action_aliases.dup
        @input_option_helpers = original.input_option_helpers.dup
        @internal_option_helpers = original.internal_option_helpers.dup
        @output_option_helpers = original.output_option_helpers.dup
        @collection_mode_class_names = original.collection_mode_class_names.dup
        @hash_mode_class_names = original.hash_mode_class_names.dup
        @action_rescue_handlers = original.action_rescue_handlers.dup

        rebind_dynamic_option_helpers!
      end

      private

      def rebind_dynamic_option_helpers!
        new_consists_of = Servactory::ToolKit::DynamicOptions::ConsistsOf
                          .use(collection_mode_class_names: @collection_mode_class_names)
        new_schema = Servactory::ToolKit::DynamicOptions::Schema
                     .use(default_hash_mode_class_names: @hash_mode_class_names)

        [@input_option_helpers, @internal_option_helpers, @output_option_helpers].each do |helpers|
          helpers.replace(name: :consists_of, with: new_consists_of)
          helpers.replace(name: :schema, with: new_schema)
        end
      end
    end
  end
end
