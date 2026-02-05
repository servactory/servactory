# frozen_string_literal: true

module Servactory
  module Maintenance
    module Options
      class Helper
        attr_reader :name,
                    :equivalent,
                    :meta

        def initialize(name:, equivalent:, meta: {})
          @name = name
          @equivalent = equivalent
          @meta = meta
        end

        def dynamic_option?
          meta[:type] == :dynamic_option
        end
      end
    end
  end
end
