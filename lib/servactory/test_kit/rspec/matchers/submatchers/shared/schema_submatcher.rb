# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Matchers
        module Submatchers
          module Shared
            # Submatcher for validating Hash schema definitions.
            #
            # ## Purpose
            #
            # Validates that a Hash attribute has the expected schema definition.
            # Schemas define the structure and types of keys within a Hash.
            #
            # ## Usage
            #
            # ```ruby
            # it { is_expected.to have_service_input(:config).schema({ api_key: String }) }
            # it { is_expected.to have_service_input(:user_data).schema({ name: String, age: Integer }) }
            # ```
            #
            # ## Note
            #
            # Requires the `:types` option to be set first (via `.type` chain).
            # Uses RSpec's `match` matcher for schema comparison.
            class SchemaSubmatcher < Base::Submatcher
              # Option name in attribute data
              OPTION_NAME = :schema
              # Key for the schema value within the option
              OPTION_BODY_KEY = :is

              # Creates a new schema submatcher.
              #
              # @param context [Base::SubmatcherContext] The submatcher context
              # @param schema_data [Hash] Expected schema definition
              # @return [SchemaSubmatcher] New submatcher instance
              def initialize(context, schema_data)
                super(context)
                @schema_data = schema_data
              end

              # Returns description for RSpec output.
              #
              # @return [String] Human-readable description with schema
              def description
                "schema: #{schema_data}"
              end

              protected

              # Checks if the attribute schema matches expected schema.
              #
              # @return [Boolean] True if schemas match
              def passes?
                attribute_schema = attribute_data.fetch(OPTION_NAME)
                @attribute_schema_is = attribute_schema.fetch(OPTION_BODY_KEY)
                @attribute_schema_message = attribute_schema.fetch(:message)

                schema_data_equal?
              end

              # Builds the failure message for schema validation.
              #
              # @return [String] Failure message with expected vs actual schema
              def build_failure_message
                return "" if schema_data_equal?

                <<~MESSAGE
                  should be schema with corresponding template

                    expected #{@attribute_schema_is.inspect}
                         got #{schema_data.inspect}
                MESSAGE
              end

              private

              attr_reader :schema_data

              # Compares expected and actual schemas using RSpec's match matcher.
              #
              # @return [Boolean] True if schemas are equal
              def schema_data_equal?
                @schema_data_equal ||= begin
                  matcher_result = RSpec::Expectations::ExpectationHelper
                                   .with_matcher(
                                     RSpec::Expectations::PositiveExpectationHandler,
                                     RSpec::Matchers::BuiltIn::Match.new(schema_data),
                                     nil
                                   ) { |matcher| matcher.matches?(@attribute_schema_is) }

                  (schema_data.present? && matcher_result) || schema_data.blank?
                end
              end
            end
          end
        end
      end
    end
  end
end
