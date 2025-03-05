# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Schema
      class Example10 < ApplicationService::Base
        PAYLOAD_SCHEMA = {
          issued_on: {
            type: [Date, DateTime, Time],
            required: true,
            prepare: ->(value:) { value.strftime("%Y-%m-%d") }
          }
        }.freeze
        private_constant :PAYLOAD_SCHEMA

        internal :payload,
                 type: ::Hash,
                 schema: PAYLOAD_SCHEMA

        output :issued_on, type: String

        make :assign_internal

        make :assign_issued_on

        private

        def assign_internal
          internals.payload = {
            issued_on: DateTime.new(2023, 1, 1)
          }
        end

        def assign_issued_on
          outputs.issued_on = internals.payload.fetch(:issued_on)
        end
      end
    end
  end
end
