# frozen_string_literal: true

module Wrong
  module DynamicOptions
    module ConsistsOf
      class Example7 < ApplicationService::Base
        input :ids, type: String, consists_of: String

        def call; end
      end
    end
  end
end
