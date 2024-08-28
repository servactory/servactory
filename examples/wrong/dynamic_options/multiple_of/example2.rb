# frozen_string_literal: true

module Wrong
  module DynamicOptions
    module MultipleOf
      class Example2 < ApplicationService::Base
        input :number, type: Integer, multiple_of: 0

        make :smth

        private

        def smth
          # ...
        end
      end
    end
  end
end
