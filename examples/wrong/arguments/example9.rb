# frozen_string_literal: true

module Wrong
  module Arguments
    class Example9 < ApplicationService::Base
      input :internal, type: String

      make :smth

      private

      def smth
        # ...
      end
    end
  end
end 