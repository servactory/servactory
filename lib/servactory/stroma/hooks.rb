# frozen_string_literal: true

module Servactory
  module Stroma
    class Hooks
      extend Forwardable

      def_delegators :@collection, :each, :empty?, :size

      def initialize(collection = Set.new)
        @collection = collection
      end

      def initialize_dup(original)
        super
        @collection = original.instance_variable_get(:@collection).dup
      end

      def add(type, target_key, extension)
        @collection << Hook.new(type:, target_key:, extension:)
      end

      def before(key)
        @collection.select { |hook| hook.before? && hook.target_key == key }
      end

      def after(key)
        @collection.select { |hook| hook.after? && hook.target_key == key }
      end
    end
  end
end
