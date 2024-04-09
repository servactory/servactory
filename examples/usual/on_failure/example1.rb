# frozen_string_literal: true

module Usual
  module OnFailure
    class Example1 < ApplicationService::Base
      output :some_value, type: Symbol

      make :assign_some_value

      make :fail_validation!

      private

      def assign_some_value
        outputs.some_value = :some_value
      end

      def fail_validation!
        fail!(:validation, message: "Validation error")
      end
    end
  end
end
