# frozen_string_literal: true

module Servactory
  module Utils
    module_function

    # @param value [#to_s]
    # @return [Boolean]
    def true?(value)
      value.to_s.casecmp("true").to_i.zero?
    end
  end
end
