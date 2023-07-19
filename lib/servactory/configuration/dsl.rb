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

          child.config.input_option_helpers = config.input_option_helpers

          child.config.aliases_for_make = config.aliases_for_make
          child.config.shortcuts_for_make = config.shortcuts_for_make
        end

        def config
          @config ||= Servactory::Configuration::Setup.new
        end

        private

        def configuration(&block)
          instance_eval(&block)
        end

        def input_error_class(input_error_class)
          config.input_error_class = input_error_class
        end

        def output_error_class(output_error_class)
          config.output_error_class = output_error_class
        end

        def internal_error_class(internal_error_class)
          config.internal_error_class = internal_error_class
        end

        def failure_class(failure_class)
          config.failure_class = failure_class
        end

        def input_option_helpers(input_option_helpers)
          config.input_option_helpers.merge(input_option_helpers)
        end

        def aliases_for_make(aliases_for_make)
          config.aliases_for_make.merge(aliases_for_make)
        end

        def shortcuts_for_make(shortcuts_for_make)
          config.shortcuts_for_make.merge(shortcuts_for_make)
        end
      end
    end
  end
end
