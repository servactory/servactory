# frozen_string_literal: true

module Wrong
  module TestKit
    module Rspec
      module Matchers
        class CustomFailure < Servactory::Exceptions::Failure; end

        # Base class that configures the custom failure class
        class CustomFailureBaseService < Servactory::Base
          configuration do
            failure_class CustomFailure
          end
        end

        class CustomFailureService < CustomFailureBaseService
          input :error_type, type: Symbol

          def call
            case inputs.error_type
            when :custom
              # Uses CustomFailure because that's the configured failure_class
              fail!(:custom, message: "Custom error")
            when :base
              fail!(message: "Base error")
            end
          end
        end
      end
    end
  end
end
