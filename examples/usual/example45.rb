# frozen_string_literal: true

module Usual
  class Example45 < ApplicationService::Base
    configuration do
      aliases_for_make %i[play do_it!]
    end

    output :number, type: Integer

    play :assign_number
    make :assign_number
    do_it! :assign_number

    private

    def assign_number
      outputs.number = 7
    end
  end
end
