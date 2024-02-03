# frozen_string_literal: true

module Usual
  module Predicate
    class Example1 < ApplicationService::Base
      input :enable, type: [TrueClass, FalseClass]
      input :text, type: String
      input :number, type: Integer

      internal :prepared_text, type: String
      internal :prepared_number, type: Integer

      output :is_enabled, type: [TrueClass, FalseClass]
      output :is_really_enabled, type: [TrueClass, FalseClass]
      output :is_text_present, type: [TrueClass, FalseClass]
      output :is_prepared_text_present, type: [TrueClass, FalseClass]
      output :is_number_present, type: [TrueClass, FalseClass]
      output :is_prepared_number_present, type: [TrueClass, FalseClass]

      make :assign_internals
      make :assign_outputs

      private

      def assign_internals
        internals.prepared_text = inputs.text
        internals.prepared_number = inputs.number
      end

      def assign_outputs # rubocop:disable Metrics/AbcSize
        outputs.is_enabled = inputs.enable?
        outputs.is_really_enabled = outputs.is_enabled?
        outputs.is_text_present = inputs.text?
        outputs.is_prepared_text_present = internals.prepared_text?
        outputs.is_number_present = inputs.number?
        outputs.is_prepared_number_present = internals.prepared_number?
      end
    end
  end
end
