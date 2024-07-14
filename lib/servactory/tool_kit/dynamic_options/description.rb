# frozen_string_literal: true

module Servactory
  module ToolKit
    module DynamicOptions
      class Description
        def self.use(option_name = :description)
          new(option_name)
        end

        def initialize(option_name)
          @option_name = option_name
        end
      end
    end
  end
end
