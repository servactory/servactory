# frozen_string_literal: true

module Usual
  class Example52 < ApplicationService::Base
    input :enable, type: [TrueClass, FalseClass]
    input :text, type: String

    output :is_enabled, type: [TrueClass, FalseClass]
    output :is_text_present, type: [TrueClass, FalseClass]

    make :assign_outputs

    private

    def assign_outputs
      outputs.is_enabled = inputs.enable?
      outputs.is_text_present = inputs.text?
    end
  end
end
