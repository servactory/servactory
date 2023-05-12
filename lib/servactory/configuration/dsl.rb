# frozen_string_literal: true

module Servactory
  module Configuration
    module DSL
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        private

        def configuration(&block)
          @configuration_factory ||= Factory.new

          @configuration_factory.instance_eval(&block)
        end
      end
    end
  end
end
