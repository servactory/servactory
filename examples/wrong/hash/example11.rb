# frozen_string_literal: true

module Wrong
  module Hash
    class Example11 < ApplicationService::Base
      output :payload,
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

      make :assign_output

      private

      def assign_output
        outputs.payload = {
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
