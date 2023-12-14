# frozen_string_literal: true

module Usual
  module Inclusion
    class Example2 < ApplicationService::Base
      Event = Struct.new(:id, :event_name, keyword_init: true)

      input :event_name, type: String, inclusion: %w[created rejected approved]

      output :event, type: Event

      make :validate_input!
      make :create_event

      private

      def validate_input!
        return if inputs.event_name != "rejected"

        fail_input!(:event_name, message: "The `rejected` event cannot be used now")
      end

      def create_event
        outputs.event = Event.new(
          id: "14fe213e-1b0a-4a68-bca9-ce082db0f2c6",
          event_name: inputs.event_name
        )
      end
    end
  end
end
