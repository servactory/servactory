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

      def dup_for_inheritance # rubocop:disable Metrics/AbcSize
        dup.tap do |copy|
          copy.action_shortcuts = action_shortcuts.dup
          copy.action_aliases = action_aliases.dup
          copy.input_option_helpers = input_option_helpers.dup
          copy.internal_option_helpers = internal_option_helpers.dup
          copy.output_option_helpers = output_option_helpers.dup
          copy.collection_mode_class_names = collection_mode_class_names.dup
          copy.hash_mode_class_names = hash_mode_class_names.dup
          copy.action_rescue_handlers = action_rescue_handlers.dup
        end
      end
    end
  end
end
