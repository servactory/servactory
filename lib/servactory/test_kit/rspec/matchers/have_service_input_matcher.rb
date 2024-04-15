# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Matchers
        class HaveServiceInputMatcher # rubocop:disable Metrics/ClassLength
          attr_reader :described_class, :input_name, :options

          def initialize(example, described_class, input_name)
            @example = example
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

          def consists_of(*types) # rubocop:disable Metrics/MethodLength
            message = block_given? ? yield : nil

            add_submatcher(
              HaveServiceAttributeMatchers::ConsistsOfMatcher,
              described_class,
              :input,
              input_name,
              @option_types,
              Array(types),
              message
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

          def direct(attributes)
            add_submatcher(
              HaveServiceInputMatchers::DirectMatcher,
              example,
              described_class,
              :input,
              input_name,
              attributes
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

          attr_reader :example, :submatchers, :missing, :subject

          def add_submatcher(matcher_class, *args)
            remove_submatcher(matcher_class)
            submatchers << matcher_class.new(*args)
          end

          def remove_submatcher(matcher_class)
            submatchers.delete_if do |submatcher|
              submatcher.is_a?(matcher_class)
            end
          end

          def expectation
            "#{described_class.name} to have a service input attribute  named #{input_name}"
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
