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

          child.config.failure_class = config.failure_class

          child.config.collection_mode_class_names = config.collection_mode_class_names

          child.config.input_option_helpers = config.input_option_helpers

          child.config.aliases_for_make = config.aliases_for_make
          child.config.shortcuts_for_make = config.shortcuts_for_make
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
