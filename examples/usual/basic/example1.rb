# frozen_string_literal: true

module Usual
  module Basic
    class Example1 < ApplicationService::Base
      inputs do
        first_name type: String
        middle_name type: String, required: false
        last_name type: String
      end

      outputs { full_name type: String }

      make :assign_full_name

      private

      def assign_full_name
        outputs.full_name = [
          inputs.first_name,
          inputs.middle_name,
          inputs.last_name
        ].compact.join(" ")
      end
    end
  end
end
