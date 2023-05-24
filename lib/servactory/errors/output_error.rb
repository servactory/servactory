# frozen_string_literal: true

module Servactory
  module Errors
    class OutputError < Base
      attr_reader :message

      def initialize(message:)
        @message = message

        super(message)
      end
    end
  end
end
