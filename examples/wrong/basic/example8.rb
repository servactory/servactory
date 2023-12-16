# frozen_string_literal: true

module Wrong
  module Basic
    class Example8 < ApplicationService::Base
      output :number, type: Integer

      # NOTE: To understand this example
      # private

      # def call
      #   outputs.number = 7
      # end
    end
  end
end
