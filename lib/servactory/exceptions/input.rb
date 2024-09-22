# frozen_string_literal: true

module Servactory
  module Exceptions
    class Input < Base
      attr_reader :service,
                  :message,
                  :input_name,
                  :meta

      def initialize(context:, message:, input_name: nil, meta: nil)
        @service = context.send(:servactory_service_info)
        @message = message
        @input_name = input_name&.to_sym
        @meta = meta

        super(message)
      end
    end
  end
end
