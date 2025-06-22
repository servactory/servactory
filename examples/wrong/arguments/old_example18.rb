# frozen_string_literal: true

module Wrong
  module Arguments
    class Example3 < ApplicationService::Base
      input :inputs, type: String

      make :smth

      private

      def smth
        # ...
      end
    end
  end
end
