# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Schema
      class Example5 < ApplicationService::Base
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
          },
          message: lambda do |input:, key_name:, expected_type:, given_type:, **|
            "Problem with the value in the `#{input.name}` schema: " \
              "`#{key_name}` has `#{given_type}` instead of `#{expected_type}`"
          end
        }.freeze
        private_constant :PAYLOAD_SCHEMA

        input :payload,
              type: ::Hash,
              schema: PAYLOAD_SCHEMA

        internal :payload,
                 type: ::Hash,
                 schema: PAYLOAD_SCHEMA

        output :full_name, type: String

        make :assign_internal

        make :assign_full_name

        private

        def assign_internal
          internals.payload = inputs.payload
        end

        def assign_full_name
          outputs.full_name = [
            internals.payload.dig(:user, :first_name),
            internals.payload.dig(:user, :middle_name),
            internals.payload.dig(:user, :last_name)
          ].compact.join(" ")
        end
      end
    end
  end
end
