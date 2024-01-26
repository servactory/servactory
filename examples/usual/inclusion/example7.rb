# frozen_string_literal: true

module Usual
  module Inclusion
    class Example7 < ApplicationService::Base
      input :event_name, type: String, inclusion: %w[created rejected approved]

      internal :event_name, type: String, inclusion: %w[created rejected approved]

      output :event_name, type: String, inclusion: %w[created rejected approved]

      make :assign_attributes

      make :validate_internal!
      make :validate_output!

      private

      def assign_attributes
        # NOTE: Here we check how `inclusion` works for `internal` and `output`
        internals.event_name = inputs.event_name
        outputs.event_name = internals.event_name
      end

      def validate_internal!
        return if internals.event_name != "created"

        fail_internal!(:event_name, message: "The `created` event cannot be used now")
      end

      def validate_output!
        return if outputs.event_name != "rejected"

        fail_output!(:event_name, message: "The `rejected` event cannot be used now")
      end
    end
  end
end
