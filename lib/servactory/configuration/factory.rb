# frozen_string_literal: true

module Servactory
  module Configuration
    class Factory
      def initialize(config)
        @config = config
      end

      def input_error_class(input_error_class)
        @config.input_error_class = input_error_class
      end

      def output_error_class(output_error_class)
        @config.output_error_class = output_error_class
      end

      def internal_error_class(internal_error_class)
        @config.internal_error_class = internal_error_class
      end

      def failure_class(failure_class)
        @config.failure_class = failure_class
      end

      def collection_mode_class_names(collection_mode_class_names)
        @config.collection_mode_class_names.merge(collection_mode_class_names)
      end

      def hash_mode_class_names(hash_mode_class_names)
        @config.collection_mode_class_names.merge(hash_mode_class_names)
      end

      def input_option_helpers(input_option_helpers)
        @config.input_option_helpers.merge(input_option_helpers)
      end

      def action_aliases(action_aliases)
        @config.action_aliases.merge(action_aliases)
      end

      def shortcuts_for_make(shortcuts_for_make)
        @config.shortcuts_for_make.merge(shortcuts_for_make)
      end
    end
  end
end
