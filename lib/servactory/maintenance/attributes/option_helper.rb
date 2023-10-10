# frozen_string_literal: true

module Servactory
  module Maintenance
    module Attributes
      class OptionHelper
        attr_reader :name,
                    :equivalent

        def initialize(name:, equivalent:)
          @name = name
          @equivalent = equivalent
        end
      end
    end
  end
end
