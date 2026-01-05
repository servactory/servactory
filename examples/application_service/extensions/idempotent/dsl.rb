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

          # With `after :actions` hook, this method runs BEFORE Actions::Workspace.
          # Returning without calling super skips stage execution entirely.
          # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
          def call!(
            collection_of_inputs:,
            collection_of_internals:,
            collection_of_outputs:,
            incoming_arguments: {},
            **
          )
            settings = self.class.stroma.settings[:actions][:idempotent]
            key_input = settings[:key_input]

            return super if key_input.blank?

            store = settings[:store]

            fail!(:idempotency_error, message: "Idempotency store not configured") if store.nil?

            key = incoming_arguments[key_input]

            if key.present?
              cached_result = store.get(key)

              if cached_result.present?
                # Initialize collections manually (normally done by Context::Workspace)
                @collection_of_inputs = collection_of_inputs
                @collection_of_internals = collection_of_internals
                @collection_of_outputs = collection_of_outputs

                # Populate outputs from cache
                cached_result.each do |output_name, output_value|
                  outputs.send(:"#{output_name}=", output_value)
                end

                # Return without calling super - skips stage execution!
                return
              end
            end
            # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

            super

            # Cache the result after execution
            store.set(inputs.send(key_input), outputs.except) if key.present?
          end
        end
      end
    end
  end
end
