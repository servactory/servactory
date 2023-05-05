# frozen_string_literal: true

module Servactory
  module Utils
    module_function

    def boolean?(value)
      value.to_s.casecmp("true").to_i.zero?
    end
  end
end
