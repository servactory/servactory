# frozen_string_literal: true

module ApplicationService
  module Extensions
    module Idempotent
      # Provides idempotency for service operations.
      #
      # ## Purpose
      #
      # Ensures service operations are idempotent by caching results.
      # Uses Stroma settings to store idempotency configuration.
      #
      # ## Usage
      #
      # ```ruby
      # class MyService < ApplicationService::Base
      #   idempotent! by: :request_id, store: MyIdempotencyStore
      # end
      # ```
      #
      # ## Settings Access
      #
      # This extension uses the Stroma settings hierarchy:
      #
      # ```ruby
      # # ClassMethods:
      # stroma.settings[:actions][:idempotent][:key_input] = :request_id
      # stroma.settings[:actions][:idempotent][:store] = MyIdempotencyStore
      #
      # # InstanceMethods:
      # self.class.stroma.settings[:actions][:idempotent][:key_input]
      # ```
      #
      # ## Cross-Extension Coordination
      #
      # Extensions can read other extensions' settings:
      #
      # ```ruby
      # # transactional_settings = stroma.settings[:actions][:transactional]
      # # if transactional_settings[:enabled]
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
            stroma.settings[:actions][:idempotent][:key_input] = by
            stroma.settings[:actions][:idempotent][:store] = store
          end
        end

        module InstanceMethods
          private

          def call!(incoming_arguments: {}, **) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
            settings = self.class.stroma.settings[:actions][:idempotent]
            key_input = settings[:key_input]
            idempotency_was_cached = false
            cached_outputs = nil

            if key_input.present?
              store = settings[:store]

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
              store = settings[:store]
              key = inputs.send(key_input)

              store.set(key, outputs.except)
            end
          end
        end
      end
    end
  end
end
