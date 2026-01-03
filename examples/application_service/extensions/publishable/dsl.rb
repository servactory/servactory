# frozen_string_literal: true

module ApplicationService
  module Extensions
    module Publishable
      # Publishes events after successful service execution.
      #
      # ## Purpose
      #
      # Enables services to publish events to an event bus after success.
      # Supports multiple events with custom payloads.
      # Uses isolated extension configuration to store publish settings.
      #
      # ## Usage
      #
      # ```ruby
      # class CreateOrderService < ApplicationService::Base
      #   publishes :order_created, with: :order_payload, event_bus: EventBus
      #   publishes :notification_sent, event_bus: EventBus
      #
      #   input :order_data, type: Hash
      #
      #   private
      #
      #   def order_payload
      #     { order_id: outputs.order.id }
      #   end
      # end
      # ```
      #
      # ## Configuration Isolation
      #
      # This extension uses isolated config namespace to prevent collisions:
      #
      # ```ruby
      # extension_config(:actions, :publishable)[:configurations] ||= []
      # extension_config(:actions, :publishable)[:configurations] << {
      #   event_name: :order_created,
      #   payload_method: :order_payload,
      #   event_bus: EventBus
      # }
      # ```
      #
      # ## Shared Access (if needed)
      #
      # Extensions can coordinate by reading other configs:
      #
      # ```ruby
      # # transactional_config = extension_config(:actions, :transactional)
      # # if transactional_config[:enabled]
      # #   # publish after transaction commits
      # # end
      # ```
      module DSL
        def self.included(base)
          base.extend(ClassMethods)
          base.include(InstanceMethods)
        end

        module ClassMethods
          private

          def publishes(event_name, with: nil, event_bus: nil)
            extension_config(:actions, :publishable)[:configurations] ||= []
            extension_config(:actions, :publishable)[:configurations] << {
              event_name:,
              payload_method: with,
              event_bus:
            }
          end
        end

        module InstanceMethods
          private

          def call!(**)
            super

            configurations = self.class.extension_config(:actions, :publishable)[:configurations] || []

            configurations.each do |config|
              event_name = config[:event_name]
              payload_method = config[:payload_method]
              event_bus = config[:event_bus]

              fail!(message: "Event bus not configured") if event_bus.nil?

              payload = payload_method.present? ? send(payload_method) : {}

              event_bus.publish(event_name, payload)
            end
          end
        end
      end
    end
  end
end
