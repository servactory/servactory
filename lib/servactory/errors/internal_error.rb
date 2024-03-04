# frozen_string_literal: true

module Servactory
  module Errors
    class InternalError < Servactory::Exceptions::Base
      attr_reader :message,
                  :internal_name

      def initialize(message:, internal_name: nil)
        @message = message
        @internal_name = internal_name&.to_sym

        super(message)
      end
    end
  end
end
