# frozen_string_literal: true

module Usual
  module DeconstructKeys
    class Example3 < ApplicationService::Base
      output :full_name, type: String
      output :token, type: [String, NilClass]

      make :assign_outputs

      private

      def assign_outputs
        outputs.full_name = "John"
        outputs.token = nil
      end
    end
  end
end
