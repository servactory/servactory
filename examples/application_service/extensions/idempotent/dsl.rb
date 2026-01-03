# frozen_string_literal: true

module ApplicationService
  module Extensions
    module Idempotent
      # Provides idempotency for service operations.
      #
      # ## Purpose
      #
      # Ensures service operations are idempotent by caching results.
      # Uses isolated extension configuration to store idempotency settings.
      #
      # ## Usage
      #
      # ```ruby
      # class MyService < ApplicationService::Base
      #   idempotent! by: :request_id, store: MyIdempotencyStore
      # end
      # ```
      #
      # ## Configuration Isolation
      #
      # This extension uses isolated config namespace to prevent collisions:
      #
      # ```ruby
      # extension_config(:actions, :idempotent)[:key_input] = :request_id
      # extension_config(:actions, :idempotent)[:store] = MyIdempotencyStore
      # ```
      #
      # ## Shared Access (if needed)
      #
      # Extensions can coordinate by reading other configs:
      #
      # ```ruby
      # # transactional_config = extension_config(:actions, :transactional)
      # # if transactional_config[:enabled]
      # #   # coordinate with transactional extension
      # # end
      # ```
      module DSL
        def self.included(base)
          base.extend(ClassMethods)
          base.include(InstanceMethods)
        end

        module ClassMethods
          private

          def idempotent!(by:, store: nil)
            extension_config(:actions, :idempotent)[:key_input] = by
            extension_config(:actions, :idempotent)[:store] = store
          end
        end

        module InstanceMethods
          private

          def call!(incoming_arguments: {}, **) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
            config = self.class.extension_config(:actions, :idempotent)
            key_input = config[:key_input]
            idempotency_was_cached = false
            cached_outputs = nil

            if key_input.present?
              store = config[:store]

              fail!(:idempotency_error, message: "Idempotency store not configured") if store.nil?

              key = incoming_arguments[key_input]

              if key.present?
                cached_result = store.get(key)

                if cached_result.present?
                  idempotency_was_cached = true
                  cached_outputs = cached_result
                end
              end
            end

            super

            return if key_input.nil?

            if idempotency_was_cached
              cached_outputs.each do |output_name, output_value|
                outputs.send(:"#{output_name}=", output_value)
              end
            else
              store = config[:store]
              key = inputs.send(key_input)

              store.set(key, outputs.except)
            end
          end
        end
      end
    end
  end
end
