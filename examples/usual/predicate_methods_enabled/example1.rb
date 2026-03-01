# frozen_string_literal: true

module Usual
  module PredicateMethodsEnabled
    class Example1 < ApplicationService::Base
      configuration do
        predicate_methods_enabled false
      end

      input :first_name, type: String
      input :middle_name, type: String, required: false
      input :last_name, type: String

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
