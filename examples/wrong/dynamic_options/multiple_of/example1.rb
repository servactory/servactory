# frozen_string_literal: true

module Wrong
  module DynamicOptions
    module MultipleOf
      class Example1 < ApplicationService::Base
        input :number, type: Integer, multiple_of: nil

        make :smth

        private

        def smth
          # ...
        end
      end
    end
  end
end
