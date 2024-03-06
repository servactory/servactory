# frozen_string_literal: true

module Servactory
  module Errors
    # DEPRECATED: This class will be deleted after release 2.4.
    class InputError < Servactory::Exceptions::Base
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
