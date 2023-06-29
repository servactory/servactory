# frozen_string_literal: true

module Usual
  class Example52 < ApplicationService::Base
    input :enable, type: [TrueClass, FalseClass]
    input :text, type: String

    internal :prepared_text, type: String

    output :is_enabled, type: [TrueClass, FalseClass]
    output :is_really_enabled, type: [TrueClass, FalseClass]
    output :is_text_present, type: [TrueClass, FalseClass]
    output :is_prepared_text_present, type: [TrueClass, FalseClass]

    make :assign_internals
    make :assign_outputs

    private

    def assign_internals
      internals.prepared_text = inputs.text
    end

    def assign_outputs
      outputs.is_enabled = inputs.enable?
      outputs.is_really_enabled = outputs.is_enabled?
      outputs.is_text_present = inputs.text?
      outputs.is_prepared_text_present = internals.prepared_text?
    end
  end
end
