# frozen_string_literal: true

module Servactory
  module Stroma
    # Manages global registration of DSL modules for Servactory.
    #
    # ## Purpose
    #
    # Singleton registry that stores all DSL modules that will be included
    # in service classes. Implements two-phase lifecycle: registration
    # followed by finalization.
    #
    # ## Usage
    #
    # ```ruby
    # # During gem initialization:
    # Stroma::Registry.register(:inputs, Inputs::DSL)
    # Stroma::Registry.register(:outputs, Outputs::DSL)
    # Stroma::Registry.finalize!
    #
    # # After finalization:
    # Stroma::Registry.keys       # => [:inputs, :outputs]
    # Stroma::Registry.key?(:inputs)  # => true
    # ```
    #
    # ## Integration
    #
    # Used by Stroma::DSL to include all registered modules in service classes.
    # Used by HooksFactory to validate hook target keys.
    #
    # ## Thread Safety
    #
    # Registration must occur during single-threaded boot phase.
    # After finalization, all read operations are thread-safe.
    class Registry
      include Singleton

      class << self
        delegate :register,
                 :finalize!,
                 :entries,
                 :keys,
                 :key?,
                 to: :instance
      end

      def initialize
        @entries = []
        @finalized = false
      end

      def register(key, extension)
        raise Exceptions::RegistryFrozen, "Registry is finalized" if @finalized

        if @entries.any? { |e| e.key == key }
          raise Exceptions::KeyAlreadyRegistered, "Key #{key.inspect} already registered"
        end

        @entries << Entry.new(key:, extension:)
      end

      def finalize!
        return if @finalized

        @entries.freeze
        @finalized = true
      end

      def entries
        ensure_finalized!
        @entries
      end

      def keys
        ensure_finalized!
        @entries.map(&:key)
      end

      def key?(key)
        ensure_finalized!
        @entries.any? { |e| e.key == key }
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
