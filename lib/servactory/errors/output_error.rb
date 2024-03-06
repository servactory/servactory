# frozen_string_literal: true

module Servactory
  module Errors
    # DEPRECATED: This class will be deleted after release 2.4.
    class OutputError < Servactory::Exceptions::Base
      attr_reader :message,
                  :output_name,
                  :meta

      def initialize(message:, output_name: nil, meta: nil)
        @message = message
        @output_name = output_name&.to_sym
        @meta = meta

        super(message)
      end
    end
  end
end
