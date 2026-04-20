# frozen_string_literal: true

module Usual
  module Arguments
    class Example3 < ApplicationService::Base
      input :activated, type: [TrueClass, FalseClass], required: false, default: false

      internal :activated, type: [TrueClass, FalseClass]

      output :activated, type: [TrueClass, FalseClass]

      make :assign_internal_activated
      make :assign_output_activated

      private

      def assign_internal_activated
        internals.activated = inputs.activated
      end

      def assign_output_activated
        outputs.activated = internals.activated
      end
    end
  end
end
