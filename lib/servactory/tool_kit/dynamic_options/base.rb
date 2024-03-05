# frozen_string_literal: true

module Servactory
  module ToolKit
    module DynamicOptions
      class Base
        def initialize(option_name)
          @option_name = option_name
        end

        def setup(name)
          Servactory::Maintenance::Attributes::OptionHelper.new(
            name: @option_name,
            equivalent: equivalent_with(name)
          )
        end

        def equivalent_with(name)
          lambda do |data|
            received_value = (data.is_a?(Hash) && data.key?(:is) ? data[:is] : data)

            {
              must: {
                name => must_content_with(received_value)
              }
            }
          end
        end

        def must_content_with(_received_value)
          raise "Need to implement `must_content_with(received_value)` method"
        end
      end
    end
  end
end
