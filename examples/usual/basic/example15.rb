# frozen_string_literal: true

module Usual
  module Basic
    class Example15 < ApplicationService::Base
      input :first_name, type: String
      input :middle_name, type: String
      input :last_name, type: String
      input :gender, type: String

      output :first_name, type: String
      output :middle_name, type: String
      output :last_name, type: String
      output :full_name, type: String

      make :assign_prepared_names
      make :assign_full_name

      private

      def assign_prepared_names
        outputs.first_name = inputs.first_name.upcase
        outputs.middle_name = inputs.middle_name.upcase
        outputs.last_name = inputs.last_name.upcase
      end

      def assign_full_name
        outputs.full_name = outputs.except(:gender).values.compact.join(" ")
      end
    end
  end
end
