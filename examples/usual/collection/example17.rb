# frozen_string_literal: true

module Usual
  module Collection
    class Example17 < ApplicationService::Base
      input :letters, type: Array, consists_of: String

      internal :letters, type: Array, consists_of: String

      output :letters, type: Array, consists_of: String
      output :desired_letter, type: String

      make :assign_internal
      make :assign_output
      make :assign_desired_letter

      private

      def assign_internal
        internals.letters = inputs.letters
      end

      def assign_output
        outputs.letters = internals.letters
      end

      def assign_desired_letter
        outputs.desired_letter = outputs.letters.second.third.first
      end
    end
  end
end
