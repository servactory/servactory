# frozen_string_literal: true

module Wrong
  module Arguments
    class Example1 < ApplicationService::Base
      input :input, type: String

      make :smth

      private

      def smth
        # ...
      end
    end
  end
end 