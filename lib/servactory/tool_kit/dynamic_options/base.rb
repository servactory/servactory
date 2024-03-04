# frozen_string_literal: true

module Servactory
  module ToolKit
    module DynamicOptions
      class Base
        def initialize(name)
          @name = name
        end

        def setup
          Servactory::Maintenance::Attributes::OptionHelper.new(
            name: @name,
            equivalent: equivalent
          )
        end

        def equivalent
          raise "Need to implement `equivalent` method"
        end
      end
    end
  end
end
