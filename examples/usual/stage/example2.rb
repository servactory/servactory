# frozen_string_literal: true

module Usual
  module Stage
    class Example2Transaction
      def self.transaction
        yield
      end
    end

    class Example2 < ApplicationService::Base
      output :number, type: Integer

      make :assign_number_4

      stage do
        wrap_in ->(methods:) { Example2Transaction.transaction { methods.call } }

        make :assign_number_5
        make :assign_number_6
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
