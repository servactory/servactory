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
              self.published_events << { name: event_name, payload: }
            end
          end
        end

        input :user_id, type: Integer

        output :full_name, type: String

        publishes :user_created, with: :event_payload, event_bus: LikeAnEventBus

        make :fail_before_publish

        private

        def fail_before_publish
          fail!(:user_creation_failed, message: "Failed to create user")
        end

        def event_payload
          { user_id: inputs.user_id, full_name: outputs.full_name }
        end
      end
    end
  end
end
