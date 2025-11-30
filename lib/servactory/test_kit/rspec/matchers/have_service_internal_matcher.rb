# frozen_string_literal: true

require_relative "have_service_attribute_matchers/types_matcher"
require_relative "have_service_attribute_matchers/consists_of_matcher"
require_relative "have_service_attribute_matchers/schema_matcher"
require_relative "have_service_attribute_matchers/inclusion_matcher"
require_relative "have_service_attribute_matchers/target_matcher"
require_relative "have_service_attribute_matchers/must_matcher"
require_relative "have_service_attribute_matchers/message_matcher"

module Servactory
  module TestKit
    module Rspec
      module Matchers
        class HaveServiceInternalMatcher # rubocop:disable Metrics/ClassLength
          attr_reader :described_class, :internal_name, :options

          def initialize(described_class, internal_name)
            @described_class = described_class
            @internal_name = internal_name

            @options = {}
            @submatchers = []

            @missing = ""
          end

          def supports_block_expectations?
            true
          end

          def type(type)
            @option_types = Array(type)
            add_submatcher(
              HaveServiceAttributeMatchers::TypesMatcher,
              described_class,
              :internal,
              internal_name,
              @option_types
            )
            self
          end

          def types(*types)
            @option_types = types
            add_submatcher(
              HaveServiceAttributeMatchers::TypesMatcher,
              described_class,
              :internal,
              internal_name,
              @option_types
            )
            self
          end

          def consists_of(*types)
            add_submatcher(
              HaveServiceAttributeMatchers::ConsistsOfMatcher,
              described_class,
              :internal,
              internal_name,
              @option_types,
              Array(types)
            )
            self
          end

          def schema(data = {})
            add_submatcher(
              HaveServiceAttributeMatchers::SchemaMatcher,
              described_class,
              :internal,
              internal_name,
              @option_types,
              data
            )
            self
          end

          def inclusion(values)
            add_submatcher(
              HaveServiceAttributeMatchers::InclusionMatcher,
              described_class,
              :internal,
              internal_name,
              Array(values)
            )
            self
          end

          def must(*must_names)
            add_submatcher(
              HaveServiceAttributeMatchers::MustMatcher,
              described_class,
              :internal,
              internal_name,
              Array(must_names)
            )
            self
          end

          def message(message)
            add_submatcher(
              HaveServiceAttributeMatchers::MessageMatcher,
              described_class,
              :internal,
              internal_name,
              @last_submatcher,
              message
            )
            self
          end

          def target(values, options = {})
            add_submatcher(
              HaveServiceAttributeMatchers::TargetMatcher,
              described_class,
              :internal,
              internal_name,
              options.fetch(:name, :target), # option_name
              Array(values)
            )
            self
          end

          def description
            "#{internal_name} with #{submatchers.map(&:description).join(', ')}"
          end

          def failure_message
            "Expected #{expectation}, which #{missing_options}"
          end

          def failure_message_when_negated
            "Did not expect #{expectation} with specified options"
          end

          def matches?(subject)
            @subject = subject

            submatchers_match?
          end

          protected

          attr_reader :last_submatcher, :submatchers, :missing, :subject

          def add_submatcher(matcher_class, *args)
            remove_submatcher(matcher_class)
            @last_submatcher = matcher_class.new(*args)
            submatchers << @last_submatcher
          end

          def remove_submatcher(matcher_class)
            submatchers.delete_if do |submatcher|
              submatcher.is_a?(matcher_class)
            end
          end

          def expectation
            "#{described_class.name} to have a service internal attribute named #{internal_name}"
          end

          def missing_options
            missing_options = [missing, missing_options_for_failing_submatchers]
            missing_options.flatten.select(&:present?).join(", ")
          end

          def failing_submatchers
            @failing_submatchers ||= submatchers.reject do |matcher|
              matcher.matches?(subject)
            end
          end

          def missing_options_for_failing_submatchers
            if defined?(failing_submatchers)
              failing_submatchers.map(&:missing_option)
            else
              []
            end
          end

          def submatchers_match?
            failing_submatchers.empty?
          end
        end
      end
    end
  end
end
