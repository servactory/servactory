# frozen_string_literal: true

module Usual
  module DeconstructKeys
    class Example1 < ApplicationService::Base
      output :full_name, type: String
      output :age, type: Integer

      make :assign_outputs

      private

      def assign_outputs
        outputs.full_name = "John"
        outputs.age = 25
      end
    end
  end
end
