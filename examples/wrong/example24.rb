# frozen_string_literal: true

module Wrong
  class Example24 < ApplicationService::Base
    input :payload,
          type: Hash,
          schema: {
            request_id: { type: String, required: true },
            user: {
              type: Hash,
              required: true,
              first_name: { type: String, required: true },
              middle_name: { type: String, required: false },
              last_name: { type: String, required: true }
            }
          }

    def call; end
  end
end
