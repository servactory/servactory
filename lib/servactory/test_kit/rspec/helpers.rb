# frozen_string_literal: true

require_relative "helpers/concerns/error_messages"
require_relative "helpers/concerns/service_class_validation"
require_relative "helpers/service_mock_config"
require_relative "helpers/mock_executor"
require_relative "helpers/input_validator"
require_relative "helpers/output_validator"
require_relative "helpers/argument_matchers"
require_relative "helpers/service_mock_builder"
require_relative "helpers/fluent"
require_relative "helpers/legacy"

module Servactory
  module TestKit
    module Rspec
      # RSpec helper methods for mocking Servactory services.
      #
      # ## Purpose
      #
      # Provides convenient helper methods for mocking Servactory service calls
      # in RSpec tests. Supports both a modern fluent API and backward-compatible
      # legacy methods.
      #
      # ## Usage
      #
      # Include in RSpec configuration:
      #
      # ```ruby
      # RSpec.configure do |config|
      #   config.include Servactory::TestKit::Rspec::Helpers, type: :service
      # end
      # ```
      #
      # ## Available Helpers
      #
      # **Fluent API (recommended):**
      # - `allow_service(ServiceClass)` - mock `.call` method (returns Result)
      # - `allow_service!(ServiceClass)` - mock `.call!` method (raises on failure)
      #
      # **Backward-Compatible API:**
      # - `allow_service_as_success!` / `allow_service_as_success`
      # - `allow_service_as_failure!` / `allow_service_as_failure`
      #
      # **Argument Matchers:**
      # - `including(hash)` - partial hash matching
      # - `excluding(hash)` - exclusion matching
      # - `any_inputs` - match any arguments
      # - `no_inputs` - match no arguments
      #
      # @see Helpers::Fluent for fluent API documentation
      # @see Helpers::Legacy for backward-compatible API documentation
      # @see Helpers::ArgumentMatchers for argument matcher documentation
      module Helpers
        include Helpers::ArgumentMatchers
        include Helpers::Fluent
        include Helpers::Legacy
      end
    end
  end
end
