# frozen_string_literal: true

module Wrong
  module ConfigMethod
    class Example1 < ApplicationService::Base
      make :smth

      private

      def smth
        # ...
      end

      def config
        {}
      end

      def fail!
        # ...
      end
    end
  end
end
