# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Helpers
        # RSpec argument matchers with service-friendly aliases.
        #
        # ## Purpose
        #
        # Provides semantic aliases for RSpec's argument matchers that read
        # more naturally in service testing contexts.
        #
        # ## Usage
        #
        # ```ruby
        # # Match specific inputs
        # allow_service_as_success!(Service, with: including(amount: 100))
        #
        # # Exclude certain keys
        # allow_service_as_success!(Service, with: excluding(secret: anything))
        #
        # # Match any inputs
        # allow_service_as_success!(Service, with: any_inputs)
        #
        # # Match no inputs
        # allow_service_as_success!(Service, with: no_inputs)
        # ```
        module ArgumentMatchers
          # Matches a hash containing specified key-value pairs.
          #
          # Alias for RSpec's `hash_including` with service-friendly naming.
          #
          # @param hash [Hash] Expected key-value pairs
          # @return [RSpec::Mocks::ArgumentMatchers::HashIncludingMatcher]
          #
          # @example
          #   allow_service_as_success!(Service, with: including(amount: 100))
          def including(hash)
            hash_including(hash)
          end

          # Matches a hash NOT containing specified key-value pairs.
          #
          # Alias for RSpec's `hash_excluding` with service-friendly naming.
          #
          # @param hash [Hash] Key-value pairs to exclude
          # @return [RSpec::Mocks::ArgumentMatchers::HashExcludingMatcher]
          #
          # @example
          #   allow_service_as_success!(Service, with: excluding(secret: anything))
          def excluding(hash)
            hash_excluding(hash)
          end

          # Matches any service inputs (wildcard matcher).
          #
          # Useful for "don't care" scenarios where input values don't matter.
          #
          # @return [RSpec::Mocks::ArgumentMatchers::AnyArgMatcher]
          #
          # @example
          #   allow_service_as_success!(Service, with: any_inputs)
          def any_inputs
            anything
          end

          # Matches no arguments (for services without inputs).
          #
          # @return [RSpec::Mocks::ArgumentMatchers::NoArgsMatcher]
          #
          # @example
          #   allow_service_as_success!(EmptyService, with: no_inputs)
          def no_inputs
            no_args
          end
        end
      end
    end
  end
end
