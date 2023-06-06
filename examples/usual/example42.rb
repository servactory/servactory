# frozen_string_literal: true

module Usual
  class Example42Transaction
    def self.transaction(&block) # rubocop:disable Lint/UnusedMethodArgument
      yield
    end
  end

  class Example42 < ApplicationService::Base
    output :number, type: Integer

    make :assign_number_4

    stage do
      make :assign_number_5
      make :assign_number_6
      make :assign_number_7

      wrap_in ->(methods:) { Example42Transaction.transaction { methods.call } }
      rollback :method_for_rollback
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
      # self.number = 6

      raise "bad number"
    end

    def assign_number_7
      self.number = 7
    end

    def assign_number_8
      self.number = 8
    end

    def method_for_rollback(e)
      fail!(message: "rollback with #{e.message}")
    end
  end
end
