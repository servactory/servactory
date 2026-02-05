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

    # DEPRECATED: This module is retained for backward compatibility only.
    #             It will be removed in a future major version.
    #             Use the Stroma-based `extensions do...end` block DSL instead,
    #             which provides proper per-class isolation and thread-safe hook management.
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

    # DEPRECATED: This method is retained for backward compatibility only.
    #             It will be removed in a future major version.
    #             Use the Stroma-based `extensions do...end` block DSL instead.
    #
    # WARNING: This method mutates global shared state (Extensions.registry),
    #          which is not thread-safe. The `extensions do...end` mechanism
    #          stores hooks per-class with deep copying on inheritance, ensuring
    #          proper isolation across different base classes and gems.
    def self.with_extensions(*extensions)
      Extensions.clear
      Extensions.register(*extensions)
      self
    end
  end
end
