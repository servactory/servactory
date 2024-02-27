# frozen_string_literal: true

module Wrong
  module Basic
    class Example12 < ApplicationService::Base
      make :smth

      private

      def smth
        # ...
      end

      def inputs
        # ...
      end

      def internals
        # ...
      end

      def outputs
        # ...
      end
    end
  end
end
