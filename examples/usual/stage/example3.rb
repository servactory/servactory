# frozen_string_literal: true

module Usual
  module Stage
    class Example3Transaction
      def self.transaction
        yield
      end
    end

    class Example3 < ApplicationService::Base
      output :number, type: Integer

      make :assign_number_4

      stage do
        wrap_in ->(methods:, **) { Example3Transaction.transaction { methods.call } }

        make :assign_number_5
        make :assign_number_6, position: 99
        make :assign_number_7
      end

      make :assign_number_8

      private

      def assign_number_4
        outputs.number = 4
      end

      def assign_number_5
        outputs.number = 5
      end

      def assign_number_6
        outputs.number = 6
      end

      def assign_number_7
        outputs.number = 7
      end

      def assign_number_8
        outputs.number = 8
      end
    end
  end
end
