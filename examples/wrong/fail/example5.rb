# frozen_string_literal: true

module Wrong
  module Fail
    class Example5 < ApplicationService::Base
      make :smth

      private

      def smth
        # ...
      end

      def fail_result!
        # ...
      end
    end
  end
end
