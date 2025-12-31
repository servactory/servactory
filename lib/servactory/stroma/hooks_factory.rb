# frozen_string_literal: true

module Servactory
  module Stroma
    class HooksFactory
      def initialize(hooks)
        @hooks = hooks
      end

      def before(key, *extensions)
        validate_key!(key)
        extensions.each { |extension| @hooks.add(:before, key, extension) }
      end

      def after(key, *extensions)
        validate_key!(key)
        extensions.each { |extension| @hooks.add(:after, key, extension) }
      end

      private

      def validate_key!(key)
        return if Registry.key?(key)

        raise Exceptions::UnknownHookTarget,
              "Unknown hook target: #{key.inspect}. " \
              "Valid keys: #{Registry.keys.map(&:inspect).join(', ')}"
      end
    end
  end
end
