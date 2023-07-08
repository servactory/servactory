# frozen_string_literal: true

module Usual
  class Example55 < ApplicationService::Base
    configuration do
      input_option_helpers(
        Servactory::Inputs::OptionHelpers::Types.all
      )
    end

    input :first_name, :string
    input :middle_name, :string?
    input :last_name, :string

    output :full_name, type: String

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
