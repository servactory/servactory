# frozen_string_literal: true

module Servactory
  module Info
    class Result
      attr_reader :inputs,
                  :internals,
                  :outputs,
                  :stages

      def initialize(builder)
        @inputs = builder.inputs
        @internals = builder.internals
        @outputs = builder.outputs
        @stages = builder.stages
      end
    end
  end
end
