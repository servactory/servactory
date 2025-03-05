# frozen_string_literal: true

module Wrong
  module Basic
    class Example13 < ApplicationService::Base
      input :invoice_number # without type

      make :smth

      private

      def smth
        # ...
      end
    end
  end
end
