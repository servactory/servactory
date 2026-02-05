# frozen_string_literal: true

module Servactory
  module Exceptions
    class Failure < Base
      attr_reader :type,
                  :message,
                  :meta

      def initialize(type: :base, message:, meta: nil) # rubocop:disable Style/KeywordParametersOrder
        @type = type
        @message = message
        @meta = meta

        super(message)
      end

      def method_missing(name, *_args) # rubocop:disable Naming/PredicateMethod
        @type == normalize_method_name(name)
      end

      def respond_to_missing?(name, *)
        @type == normalize_method_name(name) || super
      end

      # Pattern matching support for nested error matching.
      #
      # Returns hash of error attributes for use with case/in.
      #
      # @param keys [Array<Symbol>, nil] Keys to include, or nil for all
      # @return [Hash<Symbol, Object>] Hash with type, message, meta
      #
      # @example Nested matching in Result
      #   case result
      #   in { failure: true, error: { type: :validation, message: } }
      #     flash[:error] = message
      #   end
      def deconstruct_keys(keys)
        available = { type: @type, message: @message, meta: @meta }

        return available if keys.nil?

        available.slice(*keys)
      end

      private

      def normalize_method_name(name)
        name.to_s.chomp("?").to_sym
      end
    end
  end
end
