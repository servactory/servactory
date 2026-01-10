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

    ::Stroma::Registry.register(:configuration, Configuration::DSL)
    ::Stroma::Registry.register(:info, Info::DSL)
    ::Stroma::Registry.register(:context, Context::DSL)
    ::Stroma::Registry.register(:inputs, Inputs::DSL)
    ::Stroma::Registry.register(:internals, Internals::DSL)
    ::Stroma::Registry.register(:outputs, Outputs::DSL)
    ::Stroma::Registry.register(:actions, Actions::DSL)
    ::Stroma::Registry.finalize!

    def self.included(base)
      base.include(::Stroma::DSL)

      Extensions.registry.each { |extension| base.include(extension) }
    end

    def self.with_extensions(*extensions)
      Extensions.clear
      Extensions.register(*extensions)
      self
    end
  end
end
