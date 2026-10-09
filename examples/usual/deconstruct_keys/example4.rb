# frozen_string_literal: true

module Usual
  module DeconstructKeys
    class Example4 < ApplicationService::Base
      output :full_name, type: String
      output :token, type: [String, NilClass]
      output :nickname, type: String

      make :assign_outputs

      private

      def assign_outputs
        outputs.full_name = "John Doe"
        outputs.token = nil
      end
    end
  end
end
