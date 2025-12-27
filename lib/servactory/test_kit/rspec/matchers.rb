# frozen_string_literal: true

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
      module Matchers
        # Factory method for have_input
        def have_service_input(input_name) # rubocop:disable Naming/PredicatePrefix
          HaveServiceInputMatcher.new(described_class, input_name)
        end

        # Factory method for have_internal
        def have_service_internal(internal_name) # rubocop:disable Naming/PredicatePrefix
          HaveServiceInternalMatcher.new(described_class, internal_name)
        end

        # Factory method for have_output
        def have_service_output(output_name) # rubocop:disable Naming/PredicatePrefix
          HaveServiceOutputMatcher.new(output_name)
        end

        # Factory method for be_success_service
        def be_success_service
          Result::BeSuccessServiceMatcher.new
        end

        # Factory method for be_failure_service
        def be_failure_service
          Result::BeFailureServiceMatcher.new
        end
      end
    end
  end
end

# Register aliases
RSpec::Matchers.alias_matcher :have_input, :have_service_input
RSpec::Matchers.alias_matcher :have_internal, :have_service_internal
RSpec::Matchers.alias_matcher :have_output, :have_service_output
