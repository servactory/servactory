# frozen_string_literal: true

module Usual
  module OnFailure
    class Example1 < ApplicationService::Base
      make :fail_validation!

      private

      def fail_validation!
        fail!(:validation, message: "Validation error")
      end
    end
  end
end
