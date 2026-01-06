# frozen_string_literal: true

module Usual
  module Stage
    class Example14Transaction
      def self.transaction
        yield
      end
    end

    class Example14 < ApplicationService::Base
      output :number, type: Integer

      stage do
        only_if true
        wrap_in ->(methods:, **) { Example14Transaction.transaction { methods.call } }

        make :assign_number_5
      end

      stage do
        only_if false
        wrap_in ->(methods:, **) { Example14Transaction.transaction { methods.call } }

        make :assign_number_6
      end

      private

      def assign_number_5
        outputs.number = 5
      end

      def assign_number_6
        outputs.number = 6
      end
    end
  end
end
