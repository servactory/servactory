# frozen_string_literal: true

module Usual
  module Extensions
    module Publishable
      class Example1 < ApplicationService::Base
        LikeAnEventBus = Class.new do
          class << self
            attr_accessor :published_events

            def reset!
              self.published_events = []
            end

            def publish(event_name, payload)
              self.published_events ||= []
              self.published_events << { name: event_name, payload: }
            end
          end
        end

        input :user_id, type: Integer

        output :full_name, type: String

        publishes :user_created, with: :event_payload, event_bus: LikeAnEventBus

        make :assign_full_name

        private

        def assign_full_name
          outputs.full_name = "User #{inputs.user_id}"
        end

        def event_payload
          { user_id: inputs.user_id, full_name: outputs.full_name }
        end
      end
    end
  end
end
