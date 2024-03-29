# frozen_string_literal: true

module Usual
  module Basic
    class Example7 < ApplicationService::Base
      output :number, type: Integer

      private

      def call
        outputs.number = 7
      end
    end
  end
end
