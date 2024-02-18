# frozen_string_literal: true

module Servactory
  module Exceptions
    class Failure < Base
      attr_reader :type,
                  :message,
                  :meta

      def initialize(type:, message:, meta: nil)
        @type = type
        @message = message
        @meta = meta

        super(message)
      end
    end
  end
end
