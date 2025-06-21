# frozen_string_literal: true

module Servactory
  module Configuration
    module DSL
      def self.included(base)
        base.extend(ClassMethods)

        base.class_attribute :configuration_block
      end

      module ClassMethods
        def inherited(child)
          super

          child.send(:reset_config)
        end

        def config
          @config ||= Servactory::Configuration::Setup.build_for(self)
        end

        private

        def reset_config
          @config = nil
        end

        def configuration(&block)
          self.configuration_block = block
        end
      end
    end
  end
end
