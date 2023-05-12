# frozen_string_literal: true

module Servactory
  module Context
    class Store
      attr_reader :context

      def initialize(service_class)
        @context = service_class.new
      end
    end
  end
end
