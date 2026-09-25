# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Schema
      class Example12 < ApplicationService::Base
        PAYLOAD_SCHEMA = {
          first_name: { type: String, required: true },
          middle_name: { type: String, required: false, default: "Unknown" },
          nicknames: { type: Array, required: false }
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
