# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Schema
      class Example15 < ApplicationService::Base
        OPTIONS_DEFAULT = {}.freeze

        PAYLOAD_SCHEMA = {
          name: { type: String },
          options: {
            type: ::Hash,
            required: false,
            default: OPTIONS_DEFAULT,
            mode: { type: String, required: false, default: "light" }
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
