# frozen_string_literal: true

module Usual
  class Example14 < ApplicationService::Base
    Event = Struct.new(:id, :event_name, keyword_init: true)

    input :event_name,
          type: String,
          inclusion: {
            in: %w[created rejected approved]
          }

    output :event, type: Event

    make :create_event

    private

    def create_event
      outputs.event = Event.new(
        id: "14fe213e-1b0a-4a68-bca9-ce082db0f2c6",
        event_name: inputs.event_name
      )
    end
  end
end
