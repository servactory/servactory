# frozen_string_literal: true

module Wrong
  module Arguments
    class Example5 < ApplicationService::Base
      input :internals, type: String

      make :smth

      private

      def smth
        # ...
      end
    end
  end
end 