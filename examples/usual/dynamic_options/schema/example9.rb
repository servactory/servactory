# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Schema
      class Example9 < ApplicationService::Base
        PAYLOAD_SCHEMA = {
          issued_on: {
            type: [Date, DateTime, Time],
            required: true,
            prepare: ->(value:) { value.strftime("%Y-%m-%d") }
          }
        }.freeze
        private_constant :PAYLOAD_SCHEMA

        input :payload,
              type: ::Hash,
              schema: PAYLOAD_SCHEMA

        output :issued_on, type: String

        make :assign_issued_on

        private

        def assign_issued_on
          outputs.issued_on = inputs.payload.fetch(:issued_on)
        end
      end
    end
  end
end
