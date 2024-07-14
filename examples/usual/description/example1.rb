# frozen_string_literal: true

module Usual
  module Description
    class Example1 < ApplicationService::Base
      input :id, type: String, note: "Payment identifier in an external system"

      make :smth

      private

      def smth
        # ...
      end
    end
  end
end
