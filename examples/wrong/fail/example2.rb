# frozen_string_literal: true

module Wrong
  module Fail
    class Example2 < ApplicationService::Base
      output :number, type: Integer

      make :assign_number

      private

      def assign_number
        fail!(message: "There's some problem with `number`")

        outputs.number = 123
      end
    end
  end
end
