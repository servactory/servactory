# frozen_string_literal: true

module Usual
  class Example10 < ApplicationService::Base
    Event = Struct.new(:id, :event_name)

    input :event_name, type: String, inclusion: %w[created rejected approved]

    output :event, type: Event

    stage do
      make :validate_input!
      make :create_event
    end

    private

    def validate_input!
      return if inputs.event_name != "rejected"

      fail_input!(:event_name, "The `rejected` event cannot be used now", prefix: false)
    end

    def create_event
      self.event = Event.new(
        id: "14fe213e-1b0a-4a68-bca9-ce082db0f2c6",
        event_name: inputs.event_name
      )
    end
  end
end
