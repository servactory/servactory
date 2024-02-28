# frozen_string_literal: true

module Servactory
  module Errors
    class Failure < Servactory::Exceptions::Base
      attr_reader :type,
                  :message,
                  :meta

      def initialize(type: :base, message:, meta: nil) # rubocop:disable Style/KeywordParametersOrder
        @type = type
        @message = message
        @meta = meta

        super(message)
      end
    end
  end
end
