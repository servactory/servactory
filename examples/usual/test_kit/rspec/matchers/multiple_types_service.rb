# frozen_string_literal: true

module Usual
  module TestKit
    module Rspec
      module Matchers
        class MultipleTypesService < ApplicationService::Base
          input :data, type: [String, Hash, Array]
          input :id, type: [Integer, String]

          def call
            # minimal implementation
          end
        end
      end
    end
  end
end
