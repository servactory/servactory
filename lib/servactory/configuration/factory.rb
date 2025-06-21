# frozen_string_literal: true

module Servactory
  module Configuration
    class Factory # rubocop:disable Metrics/ClassLength
      def initialize(config)
        @config = config
      end

      def input_exception_class(input_exception_class)
        return @config.input_exception_class = input_exception_class if subclass_of_exception?(input_exception_class)

        raise_error_about_wrong_exception_class_with(:input_exception_class, input_exception_class)
      end

      def internal_exception_class(internal_exception_class)
        if subclass_of_exception?(internal_exception_class)
          return @config.internal_exception_class = internal_exception_class
        end

        raise_error_about_wrong_exception_class_with(:internal_exception_class, internal_exception_class)
      end

      def output_exception_class(output_exception_class)
        return @config.output_exception_class = output_exception_class if subclass_of_exception?(output_exception_class)

        raise_error_about_wrong_exception_class_with(:output_exception_class, output_exception_class)
      end

      def failure_class(failure_class)
        return @config.failure_class = failure_class if subclass_of_exception?(failure_class)

        raise_error_about_wrong_exception_class_with(:failure_class, failure_class)
      end

      def result_class(result_class)
        return @config.result_class = result_class if subclass_of_result?(result_class)

        raise_error_about_wrong_result_class_with(:result_class, result_class)
      end

      def collection_mode_class_names(collection_mode_class_names)
        @config.collection_mode_class_names.merge(collection_mode_class_names)
      end

      def hash_mode_class_names(hash_mode_class_names)
        @config.hash_mode_class_names.merge(hash_mode_class_names)
      end

      def input_option_helpers(input_option_helpers)
        @config.input_option_helpers.merge(input_option_helpers)
      end

      def internal_option_helpers(internal_option_helpers)
        @config.internal_option_helpers.merge(internal_option_helpers)
      end

      def output_option_helpers(output_option_helpers)
        @config.output_option_helpers.merge(output_option_helpers)
      end

      def action_aliases(aliases)
        if aliases.is_a?(Array)
          @config.action_aliases.merge!(aliases.to_h { |alias_name| [alias_name, true] })
        else
          @config.action_aliases.merge!(aliases)
        end
      end

      def action_shortcuts(array, hash = {}) # rubocop:disable Metrics/MethodLength
        prepared = array.to_h do |action_shortcut|
          [
            action_shortcut,
            {
              prefix: action_shortcut,
              suffix: nil
            }
          ]
        end

        prepared = prepared.merge(hash)

        @config.action_shortcuts.merge(prepared)
      end

      def i18n_root_key(value)
        return @config.i18n_root_key = value.to_s if i18n_key?(value)

        raise_error_about_wrong_i18n_root_key_with(:i18n_root_key, value)
      end

      def predicate_methods_enabled(flag)
        return @config.predicate_methods_enabled = flag if boolean?(flag)

        raise_error_about_wrong_predicate_methods_enabled_with(:predicate_methods_enabled, flag)
      end

      private

      # def action_rescue_handlers(action_rescue_handlers)
      #   @config.action_rescue_handlers.merge(action_rescue_handlers)
      # end

      def subclass_of_exception?(value)
        value.is_a?(Class) && value <= Exception
      end

      def subclass_of_result?(value)
        value.is_a?(Class) && value <= Servactory::Result
      end

      def i18n_key?(value)
        value.is_a?(Symbol) || (value.is_a?(String) && value.present?)
      end

      def boolean?(value)
        value.is_a?(TrueClass) || value.is_a?(FalseClass)
      end

      ##########################################################################

      def raise_error_about_wrong_exception_class_with(config_name, value)
        raise ArgumentError,
              "Error in `#{config_name}` configuration. " \
              "The `#{value}` value must be a subclass of `Exception`. " \
              "See configuration example here: https://servactory.com/guide/configuration"
      end

      def raise_error_about_wrong_result_class_with(config_name, value)
        raise ArgumentError,
              "Error in `#{config_name}` configuration. " \
              "The `#{value}` value must be a subclass of `Servactory::Result`. " \
              "See configuration example here: https://servactory.com/guide/configuration"
      end

      def raise_error_about_wrong_i18n_root_key_with(config_name, value)
        raise ArgumentError,
              "Error in `#{config_name}` configuration. " \
              "The `#{value.inspect}` value must be `Symbol` or `String`. " \
              "See configuration example here: https://servactory.com/guide/configuration"
      end

      def raise_error_about_wrong_predicate_methods_enabled_with(config_name, value)
        raise ArgumentError,
              "Error in `#{config_name}` configuration. " \
              "The `#{value.inspect}` value must be `TrueClass` or `FalseClass`. " \
              "See configuration example here: https://servactory.com/guide/configuration"
      end
    end
  end
end
