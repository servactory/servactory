# frozen_string_literal: true

module Servactory
  module Errors
    class Failure < Base
      attr_reader :message,
                  :meta

      def initialize(message:, meta: nil)
        @message = message
        @meta = meta

        super(message)
      end
    end
  end
end
