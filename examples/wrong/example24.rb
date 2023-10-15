# frozen_string_literal: true

module Wrong
  class Example24 < ApplicationService::Base
    input :payload,
          type: Hash,
          schema: {
            request_id: { type: String, required: true },
            user: {
              type: Hash,
              required: true
            }
          }

    def call; end
  end
end
