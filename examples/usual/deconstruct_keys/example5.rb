# frozen_string_literal: true

module Usual
  module DeconstructKeys
    class Example5 < ApplicationService::Base
      output :success, type: String
      output :error, type: String
      output :full_name, type: String

      make :assign_outputs

      private

      def assign_outputs
        outputs.success = "Saved"
        outputs.error = "None"
        outputs.full_name = "John Doe"
      end
    end
  end
end
