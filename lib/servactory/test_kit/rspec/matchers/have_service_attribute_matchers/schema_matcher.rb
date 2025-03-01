# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Matchers
        module HaveServiceAttributeMatchers
          class SchemaMatcher
            attr_reader :missing_option

            def initialize(described_class, attribute_type, attribute_name, option_types, schema_data, # rubocop:disable Metrics/MethodLength
                           custom_message)
              @described_class = described_class
              @attribute_type = attribute_type
              @attribute_type_plural = attribute_type.to_s.pluralize.to_sym
              @attribute_name = attribute_name
              @option_types = option_types
              @schema_data = schema_data
              @custom_message = custom_message

              attribute_data = described_class.info.public_send(attribute_type_plural).fetch(attribute_name)

              attribute_schema = attribute_data.fetch(:schema)
              @attribute_schema_is = attribute_schema.fetch(:is)
              @attribute_schema_message = attribute_schema.fetch(:message)

              @missing_option = ""
            end

            def description
              result = "schema: "
              result + schema_data
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
                        :custom_message,
                        :attribute_schema_is,
                        :attribute_schema_message

            def submatcher_passes?(_subject)
              matched = schema_data_equal?

              matched &&= schema_message_equal?

              matched
            end

            def schema_data_equal?
              @schema_data_equal ||=
                (
                  schema_data.present? && schema_data == attribute_schema_is
                ) || schema_data.blank?
            end

            def schema_message_equal? # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
              @schema_message_equal ||=
                if custom_message.present? && !attribute_schema_message.nil?
                  if custom_message.is_a?(RSpec::Matchers::BuiltIn::BaseMatcher)
                    RSpec::Expectations::ValueExpectationTarget
                      .new(attribute_schema_message)
                      .to(custom_message)

                    true
                  elsif attribute_schema_message.is_a?(Proc)
                    attribute_schema_message.call.casecmp(custom_message).zero?
                  else
                    attribute_schema_message.casecmp(custom_message).zero?
                  end
                else
                  true
                end
            end

            # def build_missing_option
            #   "should be schema"
            # end

            def build_missing_option # rubocop:disable Metrics/MethodLength
              unless schema_data_equal?
                return <<~MESSAGE
                  should be schema with corresponding template

                    expected #{attribute_schema_is.inspect}
                         got #{schema_data.inspect}
                MESSAGE
              end

              unless schema_message_equal? # rubocop:disable Style/GuardClause
                <<~MESSAGE
                  should be schema with expected message

                    expected #{attribute_schema_message.inspect}
                         got #{custom_message.inspect}
                MESSAGE
              end
            end
          end
        end
      end
    end
  end
end
