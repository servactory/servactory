# frozen_string_literal: true

require "singleton"

module Servactory
  module Stroma
    class Registry
      include Singleton

      Entry = Data.define(:key, :mod)

      class << self
        delegate :register, :finalize!, :find, :entries, :keys, :finalized?, to: :instance
      end

      def initialize
        @entries = []
        @keys_index = {}
        @finalized = false
      end

      def register(key, mod)
        raise FrozenError, "Registry is finalized" if @finalized
        raise ArgumentError, "Key #{key.inspect} already registered" if @keys_index.key?(key)

        entry = Entry.new(key: key, mod: mod)
        @entries << entry
        @keys_index[key] = entry
      end

      def finalize!
        return if @finalized

        @entries.freeze
        @keys_index.freeze
        @finalized = true
      end

      def entries
        ensure_finalized!
        @entries
      end

      def find(key)
        ensure_finalized!
        @keys_index[key]
      end

      def keys
        ensure_finalized!
        @keys_index.keys
      end

      def finalized?
        @finalized
      end

      private

      def ensure_finalized!
        return if @finalized

        raise "Registry not finalized. Call Stroma::Registry.finalize! after registration."
      end
    end
  end
end
