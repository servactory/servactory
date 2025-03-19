# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Schema
      class Example1 < ApplicationService::Base
        PAYLOAD_SCHEMA = {
          request_id: { type: String, required: true },
          user: {
            type: ::Hash,
            required: true,
            first_name: { type: String, required: true },
            middle_name: { type: String, required: false },
            last_name: { type: String, required: true },
            passport: {
              type: ::Hash,
              required: true,
              series: { type: String, required: true },
              number: { type: String, required: true }
            },
            session: {
              type: ::Hash,
              required: false,
              default: {}
            }
          }
        }.freeze
        private_constant :PAYLOAD_SCHEMA

        input :payload,
              type: ::Hash,
              schema: PAYLOAD_SCHEMA

        internal :payload,
                 type: ::Hash,
                 schema: PAYLOAD_SCHEMA

        output :payload,
               type: ::Hash,
               schema: PAYLOAD_SCHEMA

        output :full_name, type: String

        make :assign_internal

        make :assign_output

        make :assign_full_name

        private

        def assign_internal
          internals.payload = inputs.payload
        end

        def assign_output
          outputs.payload = internals.payload
        end

        def assign_full_name
          outputs.full_name = [
            outputs.payload.dig(:user, :first_name),
            outputs.payload.dig(:user, :middle_name),
            outputs.payload.dig(:user, :last_name)
          ].compact.join(" ")
        end
      end
    end
  end
end
