# frozen_string_literal: true

module Servactory
  module Exceptions
    class Internal < Base
      attr_reader :service,
                  :message,
                  :internal_name,
                  :meta

      def initialize(context:, message:, internal_name: nil, meta: nil)
        @context = context
        @service = context.send(:servactory_service_info)
        @message = message
        @internal_name = internal_name&.to_sym
        @meta = meta

        super(message)
      end

      private

      # API: Datory
      attr_reader :context
    end
  end
end
