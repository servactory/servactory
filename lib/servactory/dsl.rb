# frozen_string_literal: true

module Servactory
  module DSL
    module Extensions
      def self.registry
        @registry ||= []
      end

      def self.register(*extensions)
        registry.concat(extensions)
      end

      def self.clear
        @registry = []
      end
    end

    def self.included(base)
      base.include(Configuration::DSL)
      base.include(Info::DSL)
      base.include(Context::DSL)
      base.include(Inputs::DSL)
      base.include(Internals::DSL)
      base.include(Outputs::DSL)
      base.include(Actions::DSL)

      Extensions.registry.each { |extension| base.include(extension) }
    end

    def self.with_extensions(*extensions)
      Extensions.clear
      Extensions.register(*extensions)
      self
    end
  end
end
