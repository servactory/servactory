# frozen_string_literal: true

module Servactory
  module Stroma
    class Hooks
      def initialize
        @items = []
      end

      def add(type, target_key, mod)
        @items << Hook.new(type: type, target_key: target_key, mod: mod)
      end

      def before(key)
        @items.select { |hook| hook.before? && hook.target_key == key }
      end

      def after(key)
        @items.select { |hook| hook.after? && hook.target_key == key }
      end

      def empty?
        @items.empty?
      end

      def dup_for_inheritance
        self.class.new.tap do |copy|
          @items.each do |hook|
            copy.add(hook.type, hook.target_key, hook.mod)
          end
        end
      end
    end
  end
end
