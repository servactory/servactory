# frozen_string_literal: true

module Servactory
  module Info
    class Result
      attr_reader :inputs,
                  :internals,
                  :outputs

      def initialize(builder)
        @inputs = builder.inputs
        @internals = builder.internals
        @outputs = builder.outputs
      end
    end
  end
end
