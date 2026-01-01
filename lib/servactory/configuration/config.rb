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
      end
    end
  end
end
