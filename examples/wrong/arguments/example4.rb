# frozen_string_literal: true

module Wrong
  module Arguments
    class Example4 < ApplicationService::Base
      input :inputs, type: String

      make :smth

      private

      def smth
        # ...
      end
    end
  end
end
