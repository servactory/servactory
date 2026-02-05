# frozen_string_literal: true

module Usual
  module DeconstructKeys
    class Example2 < ApplicationService::Base
      output :result, type: String

      make :fail_with_validation!

      private

      def fail_with_validation!
        fail!(:validation, message: "Email is invalid", meta: { field: :email })
      end
    end
  end
end
