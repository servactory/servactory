# frozen_string_literal: true

module Servactory
  module Exceptions
    class Internal < Base
      attr_reader :service,
                  :message,
                  :internal_name,
                  :meta

      def initialize(context:, message:, internal_name: nil, meta: nil)
        @service = context.send(:servactory_service_info)
        @message = message
        @internal_name = internal_name&.to_sym
        @meta = meta

        super(message)
      end
    end
  end
end
