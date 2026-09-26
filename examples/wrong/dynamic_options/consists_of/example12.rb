# frozen_string_literal: true

module Wrong
  module DynamicOptions
    module ConsistsOf
      class Example12Collection < ::Array; end

      class Example12 < ApplicationService::Base
        configuration do
          collection_mode_class_names([Example12Collection])
        end

        input :ids, type: [String, Symbol], consists_of: String

        def call; end
      end
    end
  end
end
