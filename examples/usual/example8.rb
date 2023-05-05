# frozen_string_literal: true

module Usual
  class Example8 < ApplicationService::Base
    Event = Struct.new(:id, :event_name)

    input :event_name, type: String, inclusion: %w[created rejected approved]

    output :event, type: Event

    stage { make :create_event }

    private

    def create_event
      self.event = Event.new(
        id: "14fe213e-1b0a-4a68-bca9-ce082db0f2c6",
        event_name: inputs.event_name
      )
    end
  end
end
