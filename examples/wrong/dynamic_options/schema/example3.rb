# frozen_string_literal: true

module Wrong
  module DynamicOptions
    module Schema
      class Example3 < ApplicationService::Base
        internal :payload,
                 type: ::Hash,
                 schema: {
                   request_id: { type: String, required: true },
                   user: {
                     type: ::Hash,
                     required: true,
                     first_name: { type: String, required: true },
                     middle_name: { type: String, required: false },
                     last_name: { type: String, required: true }
                   }
                 }

        make :assign_internal

        private

        def assign_internal
          internals.payload = {
            request_id: "6e6ff7d9-6980-4c98-8fd8-ca615ccebab3",
            user: {
              first_name: "John",
              middle_name: "Fitzgerald",
              last_name: nil
            }
          }
        end
      end
    end
  end
end
