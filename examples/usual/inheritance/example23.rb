# frozen_string_literal: true

module Usual
  module Inheritance
    class Example23Base < ApplicationService::Base
      make :perform_api_request!

      private

      def perform_api_request!
        outputs.api_response = {
          api_identifier: inputs.api_identifier,
          first_name: inputs.first_name,
          middle_name: inputs.middle_name,
          last_name: inputs.last_name,
          date: inputs.date
        }
      end
    end

    class Example23 < Example23Base
      input :api_identifier, type: String

      input :first_name, type: String
      input :middle_name, type: String
      input :last_name, type: String

      input :date, type: DateTime

      output :api_response, type: Hash
    end
  end
end
