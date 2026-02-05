# frozen_string_literal: true

module Usual
  module Stage
    class Example13Transaction
      class LikeAnActiveRecordException < ArgumentError; end

      def self.transaction
        yield

        raise LikeAnActiveRecordException, "Invalid number"
      end
    end

    class Example13 < ApplicationService::Base
      output :number, type: Integer

      stage do
        wrap_in ->(methods:, **) { Example13Transaction.transaction { methods.call } }

        make :assign_number_5
        make :assign_number_6
        make :assign_number_7
      end

      private

      def assign_number_5
        outputs.number = 5
      end

      def assign_number_6
        outputs.number = 6
      end

      def assign_number_7
        outputs.number = 7
      end
    end
  end
end
