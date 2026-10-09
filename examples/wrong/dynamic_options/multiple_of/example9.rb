# frozen_string_literal: true

module Wrong
  module DynamicOptions
    module MultipleOf
      class Example9 < ApplicationService::Base
        input :number, type: [Integer, Float], multiple_of: 1.0e16

        make :smth

        private

        def smth
          # ...
        end
      end
    end
  end
end
