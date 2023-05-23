# frozen_string_literal: true

module Servactory
  module Errors
    class OutputAttributeError < Base
      attr_reader :message

      def initialize(message:)
        @message = message

        super(message)
      end
    end
  end
end
