# frozen_string_literal: true

module Usual
  class Example37Transaction
    def self.transaction(&block)
      yield if block
      # TODO: rescue Example37TransactionRollback
    end
  end

  class Example37 < ApplicationService::Base
    output :number, type: Integer

    stage do
      wrap_in Example37Transaction.transaction

      make :assign_number_5
      make :assign_number_6
      make :assign_number_7
    end

    private

    def assign_number_5
      self.number = 5
    end

    def assign_number_6
      self.number = 6
    end

    def assign_number_7
      self.number = 7
    end
  end
end
