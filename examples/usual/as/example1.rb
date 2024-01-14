# frozen_string_literal: true

module Usual
  module As
    class Example1 < ApplicationService::Base
      input :email_address, as: :email, type: String

      output :formatted_email, type: String

      make :format_email

      private

      def format_email
        outputs.formatted_email = "No Reply <#{inputs.email}>"
      end
    end
  end
end
