# frozen_string_literal: true

module Usual
  module TestKit
    module Rspec
      module Matchers
        class EmptyService < ApplicationService::Base
          def call
            # no inputs, internals, or outputs
          end
        end
      end
    end
  end
end
