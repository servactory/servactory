# frozen_string_literal: true

module Servactory
  module Configuration
    module DSL
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def inherited(child) # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
          super

          child.config.input_exception_class = config.input_exception_class
          child.config.internal_exception_class = config.internal_exception_class
          child.config.output_exception_class = config.output_exception_class

          child.config.success_class = config.success_class
          child.config.failure_class = config.failure_class

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
