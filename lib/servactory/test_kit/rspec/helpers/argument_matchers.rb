# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Helpers
        module ArgumentMatchers
          # Alias for hash_including that reads better in service context
          # Example: allow_service_as_success!(Service, with: including(amount: 100))
          def including(hash)
            hash_including(hash)
          end

          # Alias for hash_excluding
          # Example: allow_service_as_success!(Service, with: excluding(secret: anything))
          def excluding(hash)
            hash_excluding(hash)
          end

          # Match any service inputs (useful for "don't care" scenarios)
          # Example: allow_service_as_success!(Service, with: any_inputs)
          def any_inputs
            anything
          end

          # Match no arguments (for services without inputs)
          # Example: allow_service_as_success!(Service, with: no_inputs)
          def no_inputs
            no_args
          end
        end
      end
    end
  end
end
