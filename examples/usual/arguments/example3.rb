# frozen_string_literal: true

module Usual
  module Arguments
    class Example3 < ApplicationService::Base
      input :locked, type: [TrueClass, FalseClass], required: false, default: true

      internal :locked, type: [TrueClass, FalseClass]

      output :locked, type: [TrueClass, FalseClass]

      make :assign_internal_locked
      make :assign_output_locked

      private

      def assign_internal_locked
        internals.locked = inputs.locked
      end

      def assign_output_locked
        outputs.locked = internals.locked
      end
    end
  end
end
