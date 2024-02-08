# frozen_string_literal: true

module Usual
  module ActionShortcuts
    class Example1 < ApplicationService::Base
      output :number, type: Integer

      assign :number

      private

      def assign_number
        outputs.number = 7
      end
    end
  end
end
