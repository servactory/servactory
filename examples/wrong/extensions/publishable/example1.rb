# frozen_string_literal: true

module Wrong
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
              self.published_events << { name: event_name, payload: payload }
            end
          end
        end

        input :user_id, type: Integer
        input :should_fail, type: [TrueClass, FalseClass], default: false

        output :user_name, type: String

        publishes :user_created, with: :event_payload, event_bus: LikeAnEventBus

        make :assign_user_name

        private

        def assign_user_name
          fail!(:processing_error, message: "User creation failed") if inputs.should_fail

          outputs.user_name = "User #{inputs.user_id}"
        end

        def event_payload
          { user_id: inputs.user_id, user_name: outputs.user_name }
        end
      end
    end
  end
end
