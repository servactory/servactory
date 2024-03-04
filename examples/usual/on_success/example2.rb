# frozen_string_literal: true

module Usual
  module OnSuccess
    class Example2 < ApplicationService::Base
      output :number_1, type: Integer
      output :number_2, type: Integer

      private

      def call
        outputs.number_1 = 1
        outputs.number_2 = 2
      end
    end
  end
end
