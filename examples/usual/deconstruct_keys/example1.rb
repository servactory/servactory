# frozen_string_literal: true

module Usual
  module DeconstructKeys
    class Example1 < ApplicationService::Base
      output :user_name, type: String
      output :user_age, type: Integer

      make :assign_outputs

      private

      def assign_outputs
        outputs.user_name = "John"
        outputs.user_age = 25
      end
    end
  end
end
