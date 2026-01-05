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
      # Uses Stroma settings to store publish configuration.
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
      # ## Settings Access
      #
      # This extension uses the Stroma settings hierarchy:
      #
      # ```ruby
      # # ClassMethods:
      # stroma.settings[:actions][:publishable][:configurations] ||= []
      # stroma.settings[:actions][:publishable][:configurations] << {
      #   event_name: :order_created,
      #   payload_method: :order_payload,
      #   event_bus: EventBus
      # }
      #
      # # InstanceMethods:
      # self.class.stroma.settings[:actions][:publishable][:configurations]
      # ```
      #
      # ## Cross-Extension Coordination
      #
      # Extensions can read other extensions' settings:
      #
      # ```ruby
      # # transactional_settings = stroma.settings[:actions][:transactional]
      # # if transactional_settings[:enabled]
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
            stroma.settings[:actions][:publishable][:configurations] ||= []
            stroma.settings[:actions][:publishable][:configurations] << {
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

            configurations = self.class.stroma.settings[:actions][:publishable][:configurations] || []

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
