# frozen_string_literal: true

module Servactory
  module Exceptions
    class Input < Base
      attr_reader :message,
                  :input_name

      def initialize(message:, input_name: nil)
        @message = message
        @input_name = input_name&.to_sym

        super(message)
      end
    end
  end
end
