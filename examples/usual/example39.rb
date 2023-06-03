# frozen_string_literal: true

module Usual
  class Example39Transaction
    def self.transaction(&block)
      yield if block
      # TODO: rescue Example37TransactionRollback
    end
  end

  class Example39 < ApplicationService::Base
    output :number, type: Integer

    make :assign_number_4

    stage do
      wrap_in ->(methods:) { Example39Transaction.transaction { methods } }

      make :assign_number_5
      make :assign_number_6, position: 1
      make :assign_number_7
    end

    make :assign_number_8

    private

    def assign_number_4
      self.number = 4
    end

    def assign_number_5
      self.number = 5
    end

    def assign_number_6
      self.number = 6
    end

    def assign_number_7
      self.number = 7
    end

    def assign_number_8
      self.number = 8
    end
  end
end
