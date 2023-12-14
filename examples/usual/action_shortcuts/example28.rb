# frozen_string_literal: true

module Usual
  module ActionShortcuts
    class Example28 < ApplicationService::Base
      configuration do
        action_shortcuts %i[assign]
      end

      output :number, type: Integer

      assign :number

      private

      def assign_number
        outputs.number = 7
      end
    end
  end
end
