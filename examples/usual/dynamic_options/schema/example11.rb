# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Schema
      class Example11 < ApplicationService::Base
        PAYLOAD_SCHEMA = {
          issued_on: {
            type: [Date, DateTime, Time],
            required: true,
            prepare: ->(value:) { value.strftime("%Y-%m-%d") }
          }
        }.freeze
        private_constant :PAYLOAD_SCHEMA

        output :payload,
               type: ::Hash,
               schema: PAYLOAD_SCHEMA

        output :issued_on, type: String

        make :assign_output

        make :assign_issued_on

        private

        def assign_output
          outputs.payload = {
            issued_on: DateTime.new(2023, 1, 1)
          }
        end

        def assign_issued_on
          outputs.issued_on = outputs.payload.fetch(:issued_on)
        end
      end
    end
  end
end
