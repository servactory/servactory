# frozen_string_literal: true

module Wrong
  module Arguments
    class Example17 < ApplicationService::Base
      input :fail, type: String

      make :smth

      private

      def smth
        # ...
      end
    end
  end
end 