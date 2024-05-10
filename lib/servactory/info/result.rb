# frozen_string_literal: true

module Servactory
  module Info
    class Result
      attr_reader :inputs,
                  :internals,
                  :outputs

      def initialize(inputs:, internals:, outputs:)
        @inputs = inputs
        @internals = internals
        @outputs = outputs
      end
    end
  end
end
