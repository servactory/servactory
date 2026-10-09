# frozen_string_literal: true

module Wrong
  module TestKit
    module Rspec
      module Matchers
        class CustomFailure < Servactory::Exceptions::Failure; end
      end
    end
  end
end
