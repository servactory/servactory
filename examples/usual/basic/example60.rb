# frozen_string_literal: true

module Usual
  module Basic
    class Example60 < ApplicationService::Base
      input :first_name, type: String
      input :middle_name, type: String
      input :last_name, type: String
      input :gender, type: String

      internal :first_name, type: String
      internal :middle_name, type: String
      internal :last_name, type: String
      internal :gender, type: String

      output :full_name, type: String

      make :prepare_names
      make :assign_full_name

      private

      def prepare_names
        internals.first_name = inputs.first_name.upcase
        internals.middle_name = inputs.middle_name.upcase
        internals.last_name = inputs.last_name.upcase
      end

      def assign_full_name
        outputs.full_name = internals.only(:first_name, :middle_name, :last_name).values.compact.join(" ")
      end
    end
  end
end
