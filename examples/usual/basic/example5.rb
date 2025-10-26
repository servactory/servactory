# frozen_string_literal: true

module Usual
  module Basic
    class Example5 < ApplicationService::Base
      input :first_name,
            type: String,
            required: {
              message: "Input `first_name` is required"
            }
      input :middle_name, type: String, required: false
      input :last_name, type: String

      internal :prepared_full_name, type: String

      outputs { full_name type: String }

      make :prepare_full_name
      make :assign_full_name

      private

      def prepare_full_name
        internals.prepared_full_name = [
          inputs.first_name,
          inputs.middle_name,
          inputs.last_name
        ].compact.join(" ")
      end

      def assign_full_name
        outputs.full_name = internals.prepared_full_name
      end
    end
  end
end
