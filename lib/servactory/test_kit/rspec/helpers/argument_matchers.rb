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
        # **Fluent API:**
        #
        # ```ruby
        # allow_service(Service).with(including(amount: 100)).succeeds(result: "ok")
        # allow_service(Service).with(excluding(secret: anything)).succeeds(result: "ok")
        # allow_service(Service).with(any_inputs).succeeds(result: "ok")
        # allow_service(EmptyService).with(no_inputs).succeeds(result: "ok")
        # ```
        #
        # **Legacy API:**
        #
        # ```ruby
        # allow_service_as_success!(Service, with: including(amount: 100)) { { result: "ok" } }
        # allow_service_as_success!(Service, with: excluding(secret: anything)) { { result: "ok" } }
        # allow_service_as_success!(Service, with: any_inputs) { { result: "ok" } }
        # allow_service_as_success!(EmptyService, with: no_inputs) { { result: "ok" } }
        # ```
        module ArgumentMatchers
          # Matches a hash containing specified key-value pairs.
          #
          # Alias for RSpec's `hash_including` with service-friendly naming.
          #
          # @param hash [Hash] Expected key-value pairs
          # @return [RSpec::Mocks::ArgumentMatchers::HashIncludingMatcher]
          #
          # @example Fluent API
          #   allow_service(Service).with(including(amount: 100)).succeeds(result: "ok")
          #
          # @example Legacy API
          #   allow_service_as_success!(Service, with: including(amount: 100)) { { result: "ok" } }
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
          # @example Fluent API
          #   allow_service(Service).with(excluding(secret: anything)).succeeds(result: "ok")
          #
          # @example Legacy API
          #   allow_service_as_success!(Service, with: excluding(secret: anything)) { { result: "ok" } }
          def excluding(hash)
            hash_excluding(hash)
          end

          # Matches any service inputs (wildcard matcher).
          #
          # Useful for "don't care" scenarios where input values don't matter.
          #
          # @return [RSpec::Mocks::ArgumentMatchers::AnyArgMatcher]
          #
          # @example Fluent API
          #   allow_service(Service).with(any_inputs).succeeds(result: "ok")
          #
          # @example Legacy API
          #   allow_service_as_success!(Service, with: any_inputs) { { result: "ok" } }
          def any_inputs
            anything
          end

          # Matches no arguments (for services without inputs).
          #
          # @return [RSpec::Mocks::ArgumentMatchers::NoArgsMatcher]
          #
          # @example Fluent API
          #   allow_service(EmptyService).with(no_inputs).succeeds(result: "ok")
          #
          # @example Legacy API
          #   allow_service_as_success!(EmptyService, with: no_inputs) { { result: "ok" } }
          def no_inputs
            no_args
          end
        end
      end
    end
  end
end
