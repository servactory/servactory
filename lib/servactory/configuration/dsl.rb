# frozen_string_literal: true

module Servactory
  module Configuration
    module DSL
      def self.included(base)
        base.extend(ClassMethods)
        base.include(Configurable)
      end

      module ClassMethods
        def inherited(child)
          super

          child.instance_variable_set(:@config, config.dup_for_inheritance)
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
