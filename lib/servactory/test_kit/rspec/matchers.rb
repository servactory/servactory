# frozen_string_literal: true

# RSpec matchers for testing Servactory service definitions and results.
#
# ## Purpose
#
# This module provides custom RSpec matchers for validating:
# - Service attribute definitions (inputs, internals, outputs)
# - Service execution results (success/failure)
#
# ## Usage
#
# Include matchers in RSpec configuration:
#
# ```ruby
# RSpec.configure do |config|
#   config.include Servactory::TestKit::Rspec::Matchers, type: :service
# end
# ```
#
# Then use in specs:
#
# ```ruby
# RSpec.describe MyService, type: :service do
#   it { is_expected.to have_service_input(:user_id).type(Integer).required }
#   it { is_expected.to have_service_output(:result).type(String) }
#
#   it "succeeds with valid input" do
#     result = described_class.call(user_id: 123)
#     expect(result).to be_success_service.with_output(:data, "value")
#   end
# end
# ```
#
# ## Available Matchers
#
# - `have_service_input` / `have_input` - validates input attribute definitions
# - `have_service_internal` / `have_internal` - validates internal attribute definitions
# - `have_service_output` / `have_output` - validates output values on results
# - `be_success_service` - validates successful service result
# - `be_failure_service` - validates failed service result

# Concerns (must be loaded first, as they are used in Base classes)
require_relative "matchers/concerns/attribute_data_access"
require_relative "matchers/concerns/error_message_builder"
require_relative "matchers/concerns/value_comparison"

# Base classes (loaded after concerns)
require_relative "matchers/base/submatcher_context"
require_relative "matchers/base/submatcher"
require_relative "matchers/base/submatcher_registry"
require_relative "matchers/base/attribute_matcher"

# Shared submatchers
require_relative "matchers/submatchers/shared/types_submatcher"
require_relative "matchers/submatchers/shared/consists_of_submatcher"
require_relative "matchers/submatchers/shared/schema_submatcher"
require_relative "matchers/submatchers/shared/inclusion_submatcher"
require_relative "matchers/submatchers/shared/must_submatcher"
require_relative "matchers/submatchers/shared/message_submatcher"
require_relative "matchers/submatchers/shared/target_submatcher"

# Input submatchers
require_relative "matchers/submatchers/input/required_submatcher"
require_relative "matchers/submatchers/input/optional_submatcher"
require_relative "matchers/submatchers/input/default_submatcher"
require_relative "matchers/submatchers/input/valid_with_submatcher"

# Main matchers
require_relative "matchers/have_service_input_matcher"
require_relative "matchers/have_service_internal_matcher"
require_relative "matchers/have_service_output_matcher"

# Result matchers
require_relative "matchers/result/be_success_service_matcher"
require_relative "matchers/result/be_failure_service_matcher"

module Servactory
  module TestKit
    module Rspec
      # RSpec matchers for Servactory service testing.
      module Matchers
        # Creates a matcher for validating service input attribute definitions.
        #
        # @param input_name [Symbol] The name of the input to validate
        # @return [HaveServiceInputMatcher] Matcher with fluent chain methods
        #
        # @example
        #   expect(MyService).to have_service_input(:user_id)
        #     .type(Integer)
        #     .required
        def have_service_input(input_name) # rubocop:disable Naming/PredicatePrefix
          HaveServiceInputMatcher.new(described_class, input_name)
        end

        # Creates a matcher for validating service internal attribute definitions.
        #
        # @param internal_name [Symbol] The name of the internal to validate
        # @return [HaveServiceInternalMatcher] Matcher with fluent chain methods
        #
        # @example
        #   expect(MyService).to have_service_internal(:processed_data)
        #     .type(Hash)
        def have_service_internal(internal_name) # rubocop:disable Naming/PredicatePrefix
          HaveServiceInternalMatcher.new(described_class, internal_name)
        end

        # Creates a matcher for validating service result output values.
        #
        # @param output_name [Symbol] The name of the output to validate
        # @return [HaveServiceOutputMatcher] Matcher with fluent chain methods
        #
        # @example
        #   expect(result).to have_service_output(:user)
        #     .instance_of(User)
        #     .contains(name: "John")
        def have_service_output(output_name) # rubocop:disable Naming/PredicatePrefix
          HaveServiceOutputMatcher.new(output_name)
        end

        # Creates a matcher for validating successful service results.
        #
        # @return [Result::BeSuccessServiceMatcher] Matcher with output chain methods
        #
        # @example
        #   expect(result).to be_success_service
        #     .with_output(:data, "value")
        def be_success_service
          Result::BeSuccessServiceMatcher.new
        end

        # Creates a matcher for validating failed service results.
        #
        # @return [Result::BeFailureServiceMatcher] Matcher with error chain methods
        #
        # @example
        #   expect(result).to be_failure_service
        #     .type(:validation_error)
        #     .message("Invalid input")
        def be_failure_service
          Result::BeFailureServiceMatcher.new
        end
      end
    end
  end
end

# Register shorter aliases for convenience.
RSpec::Matchers.alias_matcher :have_input, :have_service_input
RSpec::Matchers.alias_matcher :have_internal, :have_service_internal
RSpec::Matchers.alias_matcher :have_output, :have_service_output
