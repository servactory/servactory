# frozen_string_literal: true

module Servactory
  module DSL
    # Legacy Extensions (сохраняется для обратной совместимости)
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

    # === РЕГИСТРАЦИЯ МОДУЛЕЙ SERVACTORY ===
    # Stroma - абстрактная система, не знает о модулях Servactory.
    # Порядок вызовов register = порядок применения модулей.
    Stroma::Registry.register(:configuration, Configuration::DSL)
    Stroma::Registry.register(:info, Info::DSL)
    Stroma::Registry.register(:context, Context::DSL)
    Stroma::Registry.register(:inputs, Inputs::DSL)
    Stroma::Registry.register(:internals, Internals::DSL)
    Stroma::Registry.register(:outputs, Outputs::DSL)
    Stroma::Registry.register(:actions, Actions::DSL)
    Stroma::Registry.finalize!

    def self.included(base)
      # Применяем DSL модули через Stroma
      base.include(Stroma::DSL)

      # Legacy extensions support (для with_extensions)
      Extensions.registry.each { |extension| base.include(extension) }
    end

    # Legacy метод (сохраняется для обратной совместимости)
    def self.with_extensions(*extensions)
      Extensions.clear
      Extensions.register(*extensions)
      self
    end
  end
end
