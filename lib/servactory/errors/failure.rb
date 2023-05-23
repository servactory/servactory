# frozen_string_literal: true

module Servactory
  module Errors
    class Failure < Base
      attr_reader :type,
                  :meta

      def initialize(error:)
        @type = error.type
        @meta = error.meta

        super(error.message)
      end
    end
  end
end
