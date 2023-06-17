# frozen_string_literal: true

module Usual
  class Example3 < ApplicationService::Base
    input :first_name, type: String
    input :middle_name, type: String, required: false
    input :last_name, type: String

    internal :prepared_full_name, type: String

    output :full_name, type: String

    make :prepare_full_name
    make :assign_full_name

    private

    def prepare_full_name
      int.prepared_full_name = [
        inp.first_name,
        inp.middle_name,
        inp.last_name
      ].compact.join(" ")
    end

    def assign_full_name
      out.full_name = int.prepared_full_name
    end
  end
end
