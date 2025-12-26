# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Matchers
        module Submatchers
          module Shared
            class MessageSubmatcher < Base::Submatcher
              OPTION_NAME = :message
              OPTION_BODY_KEY = :message

              def initialize(context, custom_message)
                super(context)
                @custom_message = custom_message
              end

              def description
                "message: #{@attribute_schema_message}"
              end

              protected

              def passes?
                last_submatcher = context.last_submatcher
                attribute_schema = attribute_data.fetch(last_submatcher.class::OPTION_NAME)
                @attribute_schema_is = attribute_schema.fetch(last_submatcher.class::OPTION_BODY_KEY)
                @attribute_schema_message = attribute_schema.fetch(:message)

                schema_message_equal?
              end

              def build_failure_message
                return "" if schema_message_equal?

                <<~MESSAGE
                  should return expected message in case of problem:

                    expected #{@attribute_schema_message.inspect}
                         got #{custom_message.inspect}
                MESSAGE
              end

              private

              attr_reader :custom_message

              def schema_message_equal? # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity
                @schema_message_equal ||= begin
                  if custom_message.present? && !@attribute_schema_message.nil?
                    if custom_message.is_a?(RSpec::Matchers::BuiltIn::BaseMatcher)
                      RSpec::Expectations::ValueExpectationTarget
                        .new(@attribute_schema_message)
                        .to(custom_message)
                      true
                    elsif @attribute_schema_message.is_a?(Proc)
                      @attribute_schema_message.call.casecmp(custom_message).zero?
                    else
                      @attribute_schema_message.casecmp(custom_message).zero?
                    end
                  else
                    true
                  end
                rescue RSpec::Expectations::ExpectationNotMetError
                  false
                end
              end
            end
          end
        end
      end
    end
  end
end
