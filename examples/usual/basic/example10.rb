# frozen_string_literal: true

module Usual
  module Basic
    class Example10 < ApplicationService::Base
      input :first_name, type: String
      input :middle_name, type: String
      input :last_name, type: String
      input :gender, type: String

      output :full_name, type: String

      make :assign_full_name

      private

      def assign_full_name
        outputs.full_name = inputs.only(:first_name, :middle_name, :last_name).values.compact.join(" ")
      end
    end
  end
end
