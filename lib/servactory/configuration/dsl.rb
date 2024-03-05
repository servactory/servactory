# frozen_string_literal: true

module Servactory
  module Configuration
    module DSL
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def inherited(child) # rubocop:disable Metrics/AbcSize
          super

          child.config.input_error_class = config.input_error_class
          child.config.internal_error_class = config.internal_error_class
          child.config.output_error_class = config.output_error_class

          child.config.success_class = config.success_class
          child.config.failure_class = config.failure_class

          child.config.collection_mode_class_names = config.collection_mode_class_names

          child.config.input_option_helpers = config.input_option_helpers
          child.config.internal_option_helpers = config.internal_option_helpers
          child.config.output_option_helpers = config.output_option_helpers

          child.config.action_aliases = config.action_aliases
          child.config.action_shortcuts = config.action_shortcuts
        end

        def config
          @config ||= Servactory::Configuration::Setup.new
        end

        private

        def configuration(&block)
          @configuration_factory ||= Factory.new(config)

          @configuration_factory.instance_eval(&block)
        end
      end
    end
  end
end
