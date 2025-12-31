# frozen_string_literal: true

require "singleton"

module Servactory
  module Stroma
    class Registry
      include Singleton

      Entry = Data.define(:key, :extension)

      class << self
        delegate :register, :finalize!, :find, :entries, :keys, :finalized?, to: :instance
      end

      def initialize
        @entries = []
        @keys_index = {}
        @finalized = false
      end

      def register(key, extension)
        raise Exceptions::RegistryFrozen, "Registry is finalized" if @finalized
        raise Exceptions::KeyAlreadyRegistered, "Key #{key.inspect} already registered" if @keys_index.key?(key)

        entry = Entry.new(key:, extension:)
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

        raise Exceptions::RegistryNotFinalized,
              "Registry not finalized. Call Stroma::Registry.finalize! after registration."
      end
    end
  end
end
