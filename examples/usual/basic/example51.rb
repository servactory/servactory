# frozen_string_literal: true

module Usual
  module Basic
    class Example51 < ApplicationService::Base
      input :first_name, type: String
      input :middle_name, type: String, required: false
      input :last_name, type: String

      output :full_name_1, type: String
      output :full_name_2, type: String
      output :full_name_3, type: String
      output :full_name_4, type: String
      output :full_name_5, type: String
      output :full_name_6, type: String
      output :full_name_7, type: String
      output :full_name_8, type: String
      output :full_name_9, type: String
      output :full_name_10, type: String

      make :assign_full_name_1
      make :assign_full_name_2
      make :assign_full_name_3
      make :assign_full_name_4
      make :assign_full_name_5
      make :assign_full_name_6
      make :assign_full_name_7
      make :assign_full_name_8
      make :assign_full_name_9
      make :assign_full_name_10

      private

      def assign_full_name_1
        outputs.full_name_1 = [inputs.first_name, inputs.middle_name, inputs.last_name].compact.join(" ")
      end

      def assign_full_name_2
        outputs.full_name_2 = [inputs.first_name, inputs.middle_name, inputs.last_name].compact.join(" ")
      end

      def assign_full_name_3
        outputs.full_name_3 = [inputs.first_name, inputs.middle_name, inputs.last_name].compact.join(" ")
      end

      def assign_full_name_4
        outputs.full_name_4 = [inputs.first_name, inputs.middle_name, inputs.last_name].compact.join(" ")
      end

      def assign_full_name_5
        outputs.full_name_5 = [inputs.first_name, inputs.middle_name, inputs.last_name].compact.join(" ")
      end

      def assign_full_name_6
        outputs.full_name_6 = [inputs.first_name, inputs.middle_name, inputs.last_name].compact.join(" ")
      end

      def assign_full_name_7
        outputs.full_name_7 = [inputs.first_name, inputs.middle_name, inputs.last_name].compact.join(" ")
      end

      def assign_full_name_8
        outputs.full_name_8 = [inputs.first_name, inputs.middle_name, inputs.last_name].compact.join(" ")
      end

      def assign_full_name_9
        outputs.full_name_9 = [inputs.first_name, inputs.middle_name, inputs.last_name].compact.join(" ")
      end

      def assign_full_name_10
        outputs.full_name_10 = [inputs.first_name, inputs.middle_name, inputs.last_name].compact.join(" ")
      end
    end
  end
end
