# frozen_string_literal: true

module Usual
  module DeconstructKeys
    class Example6 < ApplicationService::Base
      output :success, type: String
      output :error, type: String

      make :assign_outputs

      make :fail_with_validation!

      private

      def assign_outputs
        outputs.success = "Saved"
        outputs.error = "None"
      end

      def fail_with_validation!
        fail!(:validation, message: "Email is invalid")
      end
    end
  end
end
