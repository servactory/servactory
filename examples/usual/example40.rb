# frozen_string_literal: true

module Usual
  class Example40Transaction
    def self.transaction(&block)
      yield if block
    end
  end

  class Example40 < ApplicationService::Base
    output :number, type: Integer

    make :assign_number_4

    stage do
      wrap_in ->(methods:) { Example40Transaction.transaction { methods } }
      rollback :method_for_rollback

      make :assign_number_5
      make :assign_number_6
      make :assign_number_7
    end

    private

    def assign_number_4
      self.number = 4
    end

    def assign_number_5
      self.number = 5
    end

    def assign_number_6
      # self.number = 6

      raise "bad number"
    end

    def assign_number_7
      self.number = 7
    end

    def method_for_rollback(_e)
      self.number = 9
    end
  end
end
