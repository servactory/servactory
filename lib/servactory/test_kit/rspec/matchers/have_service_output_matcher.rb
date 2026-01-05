# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Matchers
        # RSpec matcher for validating service result output values.
        #
        # ## Purpose
        #
        # Validates that a service result contains an expected output value with
        # specific type, nested attributes, and content. Unlike input/internal
        # matchers that validate definitions, this matcher validates actual runtime
        # output values on a service result object.
        #
        # ## Usage
        #
        # ```ruby
        # RSpec.describe MyService, type: :service do
        #   let(:result) { described_class.call(user_id: 123) }
        #
        #   it "returns expected output" do
        #     expect(result).to have_service_output(:user)
        #       .instance_of(User)
        #       .contains(name: "John")
        #   end
        #
        #   it "validates nested attributes" do
        #     expect(result).to have_service_output(:data)
        #       .nested(:settings, :theme)
        #       .contains("dark")
        #   end
        # end
        # ```
        #
        # ## Chain Methods
        #
        # - `.instance_of(Class)` - validates output is instance of class
        # - `.nested(*methods)` - traverses nested attributes before comparison
        # - `.contains(value)` - validates output value or structure
        #
        # ## Value Comparison
        #
        # The `.contains` method uses type-aware comparison:
        # - Array - uses RSpec's `contain_exactly`
        # - Hash - uses RSpec's `match`
        # - Boolean - uses RSpec's `equal` (identity)
        # - nil - uses RSpec's `be_nil`
        # - Other - uses RSpec's `eq` (equality)
        class HaveServiceOutputMatcher # rubocop:disable Metrics/ClassLength
          include RSpec::Matchers::Composable

          # Creates a new output matcher for the given output name.
          #
          # @param output_name [Symbol] The name of the output to validate
          # @return [HaveServiceOutputMatcher] New matcher instance
          def initialize(output_name)
            @output_name = output_name
            @instance_of_class = nil
            @nested_methods = []
            @expected_value = nil
            @value_defined = false
          end

          # Indicates this matcher does not support block expectations.
          #
          # @return [Boolean] Always false
          def supports_block_expectations?
            false
          end

          # Performs the match against the actual service result.
          #
          # @param actual [Servactory::Result] The service result to validate
          # @return [Boolean] True if all checks pass
          def matches?(actual)
            @actual = actual
            @given_value = actual.public_send(output_name)

            check_instance_of && check_nested && check_contains
          end

          # Returns a description of what this matcher validates.
          #
          # @return [String] Human-readable matcher description
          def description
            "service output #{output_name}"
          end

          # Returns the failure message when the match fails.
          #
          # @return [String] Detailed failure message from RSpec matcher
          def failure_message
            match_for_failure
          end

          # Returns the failure message for negated expectations.
          #
          # @return [String] Negated failure message
          def failure_message_when_negated
            "Expected result not to have output #{output_name}"
          end

          # Chain Methods
          # -------------

          # Specifies the expected class of the output value.
          #
          # @param class_or_name [Class, String] Expected class or class name
          # @return [self] For method chaining
          def instance_of(class_or_name)
            @instance_of_class = Servactory::Utils.constantize_class(class_or_name)
            self
          end

          # Specifies nested method chain to traverse before comparison.
          #
          # Allows validating deeply nested attributes by chaining method calls
          # on the output value before performing the final comparison.
          #
          # @param methods [Array<Symbol>] Method names to call in sequence
          # @return [self] For method chaining
          #
          # @example Validate nested attribute
          #   expect(result).to have_output(:user).nested(:profile, :settings).contains(theme: "dark")
          def nested(*methods)
            @nested_methods = methods
            self
          end

          # Specifies the expected value or structure of the output.
          #
          # @param value [Object] Expected value (uses type-aware comparison)
          # @return [self] For method chaining
          def contains(value)
            @expected_value = value
            @value_defined = true
            self
          end

          private

          attr_reader :output_name,
                      :actual,
                      :given_value,
                      :instance_of_class,
                      :nested_methods,
                      :expected_value

          # Validates output value is an instance of expected class.
          #
          # @return [Boolean] True if class check passes or no class specified
          def check_instance_of # rubocop:disable Naming/PredicateMethod
            return true unless instance_of_class

            matcher = RSpec::Matchers::BuiltIn::BeAnInstanceOf.new(instance_of_class)
            matcher.matches?(@given_value)
          end

          # Traverses nested methods to get the value for comparison.
          #
          # @return [Boolean] Always true after traversing
          def check_nested # rubocop:disable Naming/PredicateMethod
            return true if nested_methods.empty?

            nested_methods.each do |method_name|
              next unless @given_value.respond_to?(method_name)

              @given_value = @given_value.public_send(method_name)
            end
            true
          end

          # Validates output value matches expected using type-aware comparison.
          #
          # @return [Boolean] True if value matches or no value specified
          def check_contains # rubocop:disable Metrics/MethodLength, Naming/PredicateMethod
            return true unless @value_defined

            matcher = case expected_value
                      when Array
                        RSpec::Matchers::BuiltIn::ContainExactly.new(expected_value)
                      when Hash
                        RSpec::Matchers::BuiltIn::Match.new(expected_value)
                      when TrueClass, FalseClass
                        RSpec::Matchers::BuiltIn::Equal.new(expected_value)
                      when NilClass
                        RSpec::Matchers::BuiltIn::BeNil.new(expected_value)
                      else
                        RSpec::Matchers::BuiltIn::Eq.new(expected_value)
                      end

            matcher.matches?(@given_value)
          end

          # Builds detailed failure message by re-running all checks.
          #
          # @return [String, Boolean] Failure message or true if no failure found
          def match_for_failure # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity
            given_value_for_check = actual.public_send(output_name)

            if instance_of_class
              matcher = RSpec::Matchers::BuiltIn::BeAnInstanceOf.new(instance_of_class)
              return matcher.failure_message unless matcher.matches?(given_value_for_check)
            end

            if nested_methods.present?
              nested_methods.each do |method_name|
                next unless given_value_for_check.respond_to?(method_name)

                given_value_for_check = given_value_for_check.public_send(method_name)
              end
            end

            return true if !@value_defined && expected_value.nil?

            matcher = case expected_value
                      when Array
                        RSpec::Matchers::BuiltIn::ContainExactly.new(expected_value)
                      when Hash
                        RSpec::Matchers::BuiltIn::Match.new(expected_value)
                      when TrueClass, FalseClass
                        RSpec::Matchers::BuiltIn::Equal.new(expected_value)
                      when NilClass
                        RSpec::Matchers::BuiltIn::BeNil.new(expected_value)
                      else
                        RSpec::Matchers::BuiltIn::Eq.new(expected_value)
                      end

            return true if matcher.matches?(given_value_for_check)

            matcher.failure_message
          end
        end
      end
    end
  end
end
