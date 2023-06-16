# frozen_string_literal: true

module Wrong
  class Example13 < ApplicationService::Base
    output :number, type: Integer

    # NOTE: To understand this example
    # private

    # def call
    #   outputs.number = 7
    # end
  end
end
