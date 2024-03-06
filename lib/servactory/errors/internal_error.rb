# frozen_string_literal: true

module Servactory
  module Errors
    # DEPRECATED: This class will be deleted after release 2.4.
    class InternalError < Servactory::Exceptions::Base
      attr_reader :message,
                  :internal_name,
                  :meta

      def initialize(message:, internal_name: nil, meta: nil)
        @message = message
        @internal_name = internal_name&.to_sym
        @meta = meta

        super(message)
      end
    end
  end
end
