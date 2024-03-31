# frozen_string_literal: true

module Servactory
  module Configuration
    class Factory
      def initialize(config)
        @config = config
      end

      # DEPRECATED: These configs must be deleted after release 2.4.
      def input_error_class(input_error_class)
        Kernel.warn "DEPRECATION WARNING: " \
                    "Configuration `input_error_class` is deprecated; " \
                    "use `internal_exception_class` instead. " \
                    "It will be removed in one of the next releases."

        input_exception_class(input_error_class)
      end

      # DEPRECATED: These configs must be deleted after release 2.4.
      def internal_error_class(internal_error_class)
        Kernel.warn "DEPRECATION WARNING: " \
                    "Configuration `internal_error_class` is deprecated; " \
                    "use `internal_exception_class` instead. " \
                    "It will be removed in one of the next releases."

        internal_exception_class(internal_error_class)
      end

      # DEPRECATED: These configs must be deleted after release 2.4.
      def output_error_class(output_error_class)
        Kernel.warn "DEPRECATION WARNING: " \
                    "Configuration `output_error_class` is deprecated; " \
                    "use `output_exception_class` instead. " \
                    "It will be removed in one of the next releases."

        output_exception_class(output_error_class)
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

      def action_aliases(action_aliases)
        @config.action_aliases.merge(action_aliases)
      end

      def action_shortcuts(action_shortcuts)
        @config.action_shortcuts.merge(action_shortcuts)
      end

      private

      # def action_rescue_handlers(action_rescue_handlers)
      #   @config.action_rescue_handlers.merge(action_rescue_handlers)
      # end

      def subclass_of_exception?(value)
        value.is_a?(Class) && value <= Exception
      end

      ##########################################################################

      def raise_error_about_wrong_exception_class_with(config_name, value)
        raise ArgumentError,
              "Error in `#{config_name}` configuration. " \
              "The `#{value}` value must be a subclass of `Exception`. " \
              "See example configuration here: https://servactory.com/guide/configuration"
      end
    end
  end
end
