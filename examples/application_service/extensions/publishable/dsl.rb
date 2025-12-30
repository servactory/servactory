# frozen_string_literal: true

module ApplicationService
  module Extensions
    module Publishable
      module DSL
        def self.included(base)
          base.extend(ClassMethods)
          base.include(InstanceMethods)
        end

        def self.register_hooks(service_class)
          service_class.after_actions(:_publish_events, priority: 80)
        end

        module ClassMethods
          private

          def publish_configurations
            @publish_configurations ||= []
          end

          def publishes(event_name, with: nil, event_bus: nil)
            publish_configurations << {
              event_name: event_name,
              payload_method: with,
              event_bus: event_bus
            }
          end
        end

        module InstanceMethods
          private

          def _publish_events(**)
            self.class.send(:publish_configurations).each do |config|
              event_name = config[:event_name]
              payload_method = config[:payload_method]
              event_bus = config[:event_bus] || default_event_bus

              payload = payload_method.present? ? send(payload_method) : {}

              event_bus.publish(event_name, payload)
            end
          end

          def default_event_bus
            fail!(message: "Event bus not configured")
          end
        end
      end
    end
  end
end
