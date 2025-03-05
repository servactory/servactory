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

        # internal :payload,
        #          type: ::Hash,
        #          schema: PAYLOAD_SCHEMA
        #
        # output :payload,
        #        type: ::Hash,
        #        schema: PAYLOAD_SCHEMA

        output :issued_on, type: String

        # make :assign_internal

        # make :assign_output

        make :assign_issued_on

        private

        # def assign_internal
        #   internals.payload = inputs.payload
        # end

        # def assign_output
        #   outputs.payload = internals.payload
        # end

        def assign_issued_on
          outputs.issued_on = inputs.payload.fetch(:issued_on)
        end
      end
    end
  end
end
