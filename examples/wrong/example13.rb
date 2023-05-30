# frozen_string_literal: true

module Wrong
  class Example13 < ApplicationService::Base
    output :number, type: Integer

    # private

    # def call
    #   self.number = 7
    # end
  end
end
