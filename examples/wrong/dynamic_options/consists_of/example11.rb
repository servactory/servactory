# frozen_string_literal: true

module Wrong
  module DynamicOptions
    module ConsistsOf
      class Example11Collection < ::Array; end

      class Example11 < ApplicationService::Base
        input :ids, type: Example11Collection, consists_of: String

        def call; end
      end
    end
  end
end
