# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Schema
      class Example14 < ApplicationService::Base
        SETTINGS_DEFAULT = { notifications: {} } # rubocop:disable Style/MutableConstant

        PAYLOAD_SCHEMA = {
          name: { type: String },
          settings: {
            type: ::Hash,
            required: false,
            default: SETTINGS_DEFAULT,
            lang: { type: String, required: false, default: "en" },
            notifications: {
              type: ::Hash,
              channel: { type: String, required: false, default: "email" }
            }
          }
        }.freeze
        private_constant :PAYLOAD_SCHEMA

        input :payload,
              type: ::Hash,
              schema: PAYLOAD_SCHEMA

        output :payload, type: ::Hash

        make :assign_payload

        private

        def assign_payload
          outputs.payload = inputs.payload
        end
      end
    end
  end
end
