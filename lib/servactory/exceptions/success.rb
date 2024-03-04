# frozen_string_literal: true

module Servactory
  module Exceptions
    class Success < Base
      attr_reader :context

      def initialize(context:)
        @context = context

        super
      end
    end
  end
end
