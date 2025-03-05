# frozen_string_literal: true

# require "rspec/expectations/expectation_target"

module Servactory
  module TestKit
    module Rspec
      module Matchers
        module HaveServiceAttributeMatchers
          class SchemaMatcher
            OPTION_NAME = :schema
            OPTION_BODY_KEY = :is

            attr_reader :missing_option

            def initialize(described_class, attribute_type, attribute_name, option_types, schema_data) # rubocop:disable Metrics/MethodLength
              @described_class = described_class
              @attribute_type = attribute_type
              @attribute_type_plural = attribute_type.to_s.pluralize.to_sym
              @attribute_name = attribute_name
              @option_types = option_types
              @schema_data = schema_data

              attribute_data = described_class.info.public_send(attribute_type_plural).fetch(attribute_name)

              attribute_schema = attribute_data.fetch(OPTION_NAME)
              @attribute_schema_is = attribute_schema.fetch(OPTION_BODY_KEY)
              @attribute_schema_message = attribute_schema.fetch(:message)

              @missing_option = ""
            end

            def description
              "schema: #{schema_data}"
            end

            def matches?(subject)
              if submatcher_passes?(subject)
                true
              else
                @missing_option = build_missing_option

                false
              end
            end

            private

            attr_reader :described_class,
                        :attribute_type,
                        :attribute_type_plural,
                        :attribute_name,
                        :option_types,
                        :schema_data,
                        :attribute_schema_is,
                        :attribute_schema_message

            def submatcher_passes?(_subject)
              schema_data_equal?
            end

            def schema_data_equal?
              # RSpec::Expectations::ExpectationTarget.new(schema_data).to(RSpec::Matchers::BuiltIn::Match.new(attribute_schema_is))

              RSpec::Expectations::ExpectationHelper
                .with_matcher(
                  RSpec::Expectations::PositiveExpectationHandler,
                  RSpec::Matchers::BuiltIn::Match.new(schema_data),
                  nil
                ) do |matcher|
                match_result = matcher.matches?(attribute_schema_is)

                # puts
                # puts :match_result
                # puts match_result.inspect
                # puts

                match_result
              end

              # puts
              # puts schema_data.inspect
              # puts
              # puts attribute_schema_is.inspect
              # puts
              # puts

              # RSpec::Expectations::PositiveExpectationHandler.handle_matcher(
              #   attribute_schema_is,
              #   RSpec::Matchers::BuiltIn::Match.new(schema_data),
              #   "message",
              #   # &block
              # )

              # true

            # rescue => e
            #   puts
            #   puts e.inspect
            #   puts
            #
            #   true
            #
            #   # @schema_data_equal ||=
            #   #   (
            #   #     schema_data.present? && schema_data == attribute_schema_is
            #   #   ) || schema_data.blank?
            #
            #   # @schema_data_equal ||= true
            end

            def build_missing_option
              return if schema_data_equal?

              <<~MESSAGE
                should be schema with corresponding template

                  expected #{attribute_schema_is.inspect}
                       got #{schema_data.inspect}
              MESSAGE
            end
          end
        end
      end
    end
  end
end
