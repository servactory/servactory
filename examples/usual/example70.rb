# frozen_string_literal: true

module Usual
  class Example70 < ApplicationService::Base
    input :payload,
          type: Hash,
          schema: {
            request_id: { type: String, required: true },
            user: {
              type: Hash,
              required: true,
              first_name: { type: String, required: true },
              middle_name: { type: String, required: false, default: "<unknown>" },
              last_name: { type: String, required: true },
              pass: {
                type: Hash,
                required: true,
                series: { type: String, required: true },
                number: { type: String, required: true }
              }
            }
          }

    internal :payload,
             type: Hash,
             schema: {
               request_id: { type: String, required: true },
               user: {
                 type: Hash,
                 required: true,
                 first_name: { type: String, required: true },
                 middle_name: { type: String, required: false, default: "<unknown>" },
                 last_name: { type: String, required: true },
                 pass: {
                   type: Hash,
                   required: true,
                   series: { type: String, required: true },
                   number: { type: String, required: true }
                 }
               }
             }

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
