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

      def method_missing(name, *args)
        @type == normalize_method_name(name)
      end

      def respond_to_missing?(name, *)
        @type == normalize_method_name(name) || super
      end

      private

      def normalize_method_name(name)
        name.to_s.chomp("?").to_sym
      end
    end
  end
end
