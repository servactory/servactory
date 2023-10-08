# frozen_string_literal: true

module Usual
  class Example65 < ApplicationService::Base
    input :ids, type: Array, consists_of: String
    # Input Option Helpers
    # input :ids, as_array_of: String
    # input :users, as_ar_of: User

    output :first_id, type: String

    make :assign_first_id

    private

    def assign_first_id
      outputs.first_id = inputs.ids.first
    end
  end
end
