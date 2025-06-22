# frozen_string_literal: true

module Wrong
  module Arguments
    class Example12 < ApplicationService::Base
      input :outputs, type: String

      make :smth

      private

      def smth
        # ...
      end
    end
  end
end 