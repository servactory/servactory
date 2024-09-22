# frozen_string_literal: true

module Servactory
  module Exceptions
    class Output < Base
      attr_reader :service,
                  :message,
                  :output_name,
                  :meta

      def initialize(context:, message:, output_name: nil, meta: nil)
        @service = context.send(:servactory_service_info)
        @message = message
        @output_name = output_name&.to_sym
        @meta = meta

        super(message)
      end
    end
  end
end
