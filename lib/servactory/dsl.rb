# frozen_string_literal: true

module Servactory
  module DSL
    STROMA = Stroma::Matrix.define(:my_lib) do
      register(:configuration, Configuration::DSL)
      register(:info, Info::DSL)
      register(:context, Context::DSL)
      register(:inputs, Inputs::DSL)
      register(:internals, Internals::DSL)
      register(:outputs, Outputs::DSL)
      register(:actions, Actions::DSL)
    end
    private_constant :STROMA

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
      base.include(STROMA.dsl)

      Extensions.registry.each { |extension| base.include(extension) }
    end

    def self.with_extensions(*extensions)
      Extensions.clear
      Extensions.register(*extensions)
      self
    end
  end
end
