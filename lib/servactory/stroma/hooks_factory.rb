# frozen_string_literal: true

module Servactory
  module Stroma
    class HooksFactory
      def initialize(hooks)
        @hooks = hooks
      end

      def before(key, *mods)
        validate_key!(key)
        mods.each { |mod| @hooks.add(:before, key, mod) }
      end

      def after(key, *mods)
        validate_key!(key)
        mods.each { |mod| @hooks.add(:after, key, mod) }
      end

      private

      def validate_key!(key)
        return if Registry.key?(key)

        raise ArgumentError,
              "Unknown hook target: #{key.inspect}. " \
              "Valid keys: #{Registry.keys.map(&:inspect).join(', ')}"
      end
    end
  end
end
