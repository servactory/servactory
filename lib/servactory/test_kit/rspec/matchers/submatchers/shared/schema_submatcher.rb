# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Matchers
        module Submatchers
          module Shared
            class SchemaSubmatcher < Base::Submatcher
              OPTION_NAME = :schema
              OPTION_BODY_KEY = :is

              def initialize(context, schema_data)
                super(context)
                @schema_data = schema_data
              end

              def description
                "schema: #{schema_data}"
              end

              protected

              def passes?
                attribute_schema = attribute_data.fetch(OPTION_NAME)
                @attribute_schema_is = attribute_schema.fetch(OPTION_BODY_KEY)
                @attribute_schema_message = attribute_schema.fetch(:message)

                schema_data_equal?
              end

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
