# frozen_string_literal: true

module Servactory
  module OldConfiguration
    module DSL
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def config
          @config ||= Servactory::OldConfiguration::Setup.new
        end

        private

        def configure(&block)
          @configuration_factory ||= Factory.new(config)

          @configuration_factory.instance_eval(&block)
        end
      end
    end
  end
end
