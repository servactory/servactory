# frozen_string_literal: true

module Usual
  module ActionAliases
    class Example1 < ApplicationService::Base
      configuration do
        action_aliases %i[play do_it!]
      end

      output :number, type: Integer

      play :assign_number
      make :assign_number
      do_it! :assign_number

      private

      def assign_number
        outputs.number = 7
      end
    end
  end
end
