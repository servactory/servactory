# frozen_string_literal: true

module Wrong
  module TestKit
    module Rspec
      module Matchers
        # Base class that configures the custom failure class
        class CustomFailureBaseService < Servactory::Base
          configuration do
            failure_class CustomFailure
          end
        end
      end
    end
  end
end
