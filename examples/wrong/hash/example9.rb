# frozen_string_literal: true

module Wrong
  module Hash
    class Example9 < ApplicationService::Base
      internal :payload,
               type: ::Hash,
               schema: {
                 is: {
                   request_id: { type: String, required: true },
                   user: {
                     type: ::Hash,
                     required: true,
                     first_name: { type: String, required: true },
                     middle_name: { type: String, required: false },
                     last_name: { type: String, required: true }
                   }
                 },
                 message: "Problem with the value in the schema"
               }

      make :assign_internal

      private

      def assign_internal
        internals.payload = {
          request_id: "6e6ff7d9-6980-4c98-8fd8-ca615ccebab3",
          user: nil
        }
      end
    end
  end
end
