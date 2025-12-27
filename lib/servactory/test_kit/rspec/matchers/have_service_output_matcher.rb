# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Matchers
        class HaveServiceOutputMatcher
          include RSpec::Matchers::Composable

          def initialize(output_name)
            @output_name = output_name
            @instance_of_class = nil
            @nested_methods = []
            @expected_value = nil
            @value_defined = false
          end

          def supports_block_expectations?
            false
          end

          def matches?(actual)
            @actual = actual
            @given_value = actual.public_send(output_name)

            check_instance_of && check_nested && check_contains
          end

          def description
            "service output #{output_name}"
          end

          def failure_message
            match_for_failure
          end

          def failure_message_when_negated
            "Expected result not to have output #{output_name}"
          end

          # Chain methods
          def instance_of(class_or_name)
            @instance_of_class = Servactory::Utils.constantize_class(class_or_name)
            self
          end

          def nested(*methods)
            @nested_methods = methods
            self
          end

          def contains(value)
            @expected_value = value
            @value_defined = true
            self
          end

          private

          attr_reader :output_name, :actual, :given_value, :instance_of_class,
                      :nested_methods, :expected_value

          def check_instance_of # rubocop:disable Naming/PredicateMethod
            return true unless instance_of_class

            matcher = RSpec::Matchers::BuiltIn::BeAnInstanceOf.new(instance_of_class)
            matcher.matches?(@given_value)
          end

          def check_nested # rubocop:disable Naming/PredicateMethod
            return true if nested_methods.empty?

            nested_methods.each do |method_name|
              next unless @given_value.respond_to?(method_name)

              @given_value = @given_value.public_send(method_name)
            end
            true
          end

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
