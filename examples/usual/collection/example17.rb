# frozen_string_literal: true

module Usual
  module Collection
    class Example17 < ApplicationService::Base
      input :codes, type: Array, consists_of: String

      internal :codes, type: Array, consists_of: String

      output :desired_code, type: String

      make :assign_internal
      make :assign_desired_code

      private

      def assign_internal
        internals.codes = inputs.codes
      end

      def assign_desired_code
        outputs.desired_code = internals.codes.second.third.first
      end
    end
  end
end
