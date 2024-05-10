# frozen_string_literal: true

module Servactory
  module Info
    class Result
      attr_reader :service,
                  :inputs,
                  :internals,
                  :outputs

      def initialize(service:, inputs:, internals:, outputs:)
        @service = service
        @inputs = inputs
        @internals = internals
        @outputs = outputs
      end
    end
  end
end
