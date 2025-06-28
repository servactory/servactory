# frozen_string_literal: true

require_relative "have_service_input_matchers/default_matcher"
require_relative "have_service_input_matchers/optional_matcher"
require_relative "have_service_input_matchers/required_matcher"
require_relative "have_service_input_matchers/valid_with_matcher"
require_relative "have_service_attribute_matchers/target_matcher"

module Servactory
  module TestKit
    module Rspec
      module Matchers
        class HaveServiceInputMatcher # rubocop:disable Metrics/ClassLength
          attr_reader :described_class, :input_name, :options

          def initialize(described_class, input_name)
            @described_class = described_class
            @input_name = input_name

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
              :input,
              input_name,
              @option_types
            )
            self
          end

          def types(*types)
            @option_types = types
            add_submatcher(
              HaveServiceAttributeMatchers::TypesMatcher,
              described_class,
              :input,
              input_name,
              @option_types
            )
            self
          end

          def required(custom_message = nil)
            remove_submatcher(HaveServiceInputMatchers::OptionalMatcher)
            add_submatcher(
              HaveServiceInputMatchers::RequiredMatcher,
              described_class,
              :input,
              input_name,
              custom_message
            )
            self
          end

          def optional
            remove_submatcher(HaveServiceInputMatchers::RequiredMatcher)
            add_submatcher(
              HaveServiceInputMatchers::OptionalMatcher,
              described_class,
              :input,
              input_name
            )
            self
          end

          def default(value)
            add_submatcher(
              HaveServiceInputMatchers::DefaultMatcher,
              described_class,
              :input,
              input_name,
              value
            )
            self
          end

          def consists_of(*types)
            add_submatcher(
              HaveServiceAttributeMatchers::ConsistsOfMatcher,
              described_class,
              :input,
              input_name,
              @option_types,
              Array(types)
            )
            self
          end

          def schema(data = {})
            add_submatcher(
              HaveServiceAttributeMatchers::SchemaMatcher,
              described_class,
              :input,
              input_name,
              @option_types,
              data
            )
            self
          end

          def inclusion(values)
            add_submatcher(
              HaveServiceAttributeMatchers::InclusionMatcher,
              described_class,
              :input,
              input_name,
              Array(values)
            )
            self
          end

          def must(*must_names)
            add_submatcher(
              HaveServiceAttributeMatchers::MustMatcher,
              described_class,
              :input,
              input_name,
              Array(must_names)
            )
            self
          end

          def valid_with(attributes)
            add_submatcher(
              HaveServiceInputMatchers::ValidWithMatcher,
              described_class,
              :input,
              input_name,
              attributes
            )
            self
          end

          def message(message)
            add_submatcher(
              HaveServiceAttributeMatchers::MessageMatcher,
              described_class,
              :input,
              input_name,
              @last_submatcher,
              message
            )
            self
          end

          def target(values, options = {})
            add_submatcher(
              HaveServiceAttributeMatchers::TargetMatcher,
              described_class,
              :input,
              input_name,
              options.fetch(:name, :target), # option_name
              Array(values)
            )
            self
          end

          # NOTE: Used for delayed chain implementation
          # def not_implemented_chain(*description)
          #   Kernel.warn <<-MESSAGE.squish
          #     This chain has not yet been implemented.
          #     This message is for informational purposes only.
          #     Description: #{description}
          #   MESSAGE
          #   self
          # end

          def description
            "#{input_name} with #{submatchers.map(&:description).join(', ')}"
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
            "#{described_class.name} to have a service input attribute named #{input_name}"
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
