# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Schema
      class Example7 < ApplicationService::Base
        PAYLOAD_SCHEMA = {
          is: {
            request_id: { type: String, required: true },
            user: {
              type: ::Hash,
              required: true,
              first_name: { type: String, required: true },
              middle_name: { type: String, required: false, default: "<unknown>" },
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
                default: {},
                visited_on: { type: Date, required: false, default: nil }
              }
            }
          }
        }.freeze
        private_constant :PAYLOAD_SCHEMA

        input :payload,
              type: ::Hash,
              schema: PAYLOAD_SCHEMA,
              required: false

        internal :payload,
                 type: [NilClass, ::Hash],
                 schema: PAYLOAD_SCHEMA

        output :full_name, type: [NilClass, String]

        make :assign_internal

        make :assign_full_name

        private

        def assign_internal
          internals.payload = inputs.payload
        end

        def assign_full_name
          outputs.full_name =
            if internals.payload.respond_to?(:dig)
              [
                internals.payload.dig(:user, :first_name),
                internals.payload.dig(:user, :middle_name),
                internals.payload.dig(:user, :last_name)
              ].compact.join(" ")
            end
        end
      end
    end
  end
end
