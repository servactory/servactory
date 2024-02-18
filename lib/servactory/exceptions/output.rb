# frozen_string_literal: true

module Servactory
  module Exceptions
    class Output < Base
      attr_reader :message,
                  :output_name

      def initialize(message:, output_name: nil)
        @message = message
        @output_name = output_name&.to_sym

        super(message)
      end
    end
  end
end
