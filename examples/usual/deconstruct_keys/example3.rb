# frozen_string_literal: true

module Usual
  module DeconstructKeys
    class Example3 < ApplicationService::Base
      output :user_name, type: String
      output :token, type: [String, NilClass]

      make :assign_outputs

      private

      def assign_outputs
        outputs.user_name = "John"
        outputs.token = nil
      end
    end
  end
end
