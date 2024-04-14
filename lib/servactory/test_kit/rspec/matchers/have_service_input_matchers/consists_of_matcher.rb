# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Matchers
        module HaveServiceInputMatchers
          class ConsistsOfMatcher
            attr_reader :missing_option

            def initialize(described_class, input_name, input_types, consists_of_types, custom_message)
              @described_class = described_class
              @input_name = input_name
              @input_types = input_types
              @consists_of_types = consists_of_types
              @custom_message = custom_message

              @input_data = described_class.info.inputs.fetch(input_name)

              @missing_option = ""
            end

            def description
              result = "consists_of: "
              result + consists_of_types.join(", ")
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

            attr_reader :described_class, :input_name, :input_types, :consists_of_types, :custom_message, :input_data

            def submatcher_passes?(_subject)
              input_consists_of = Array(input_data.fetch(:consists_of).fetch(:type) || [])

              matched = input_consists_of.difference(consists_of_types).empty?

              matched &&= input_consists_of_message.casecmp(custom_message).zero? if custom_message.present?

              matched
            end

            def input_consists_of_message # rubocop:disable Metrics/MethodLength
              input_consists_of_message = input_data.fetch(:consists_of).fetch(:message)

              if input_consists_of_message.nil?
                I18n.t(
                  "servactory.inputs.validations.required.default_error.for_collection",
                  service_class_name: described_class.name,
                  input_name: input_name
                )
              elsif input_consists_of_message.is_a?(Proc)
                input_work = input_data.fetch(:work)

                input_consists_of_message.call(
                  input: input_work,
                  expected_type: String,
                  given_type: Servactory::TestKit::FakeType.new.class.name
                )
              else
                input_consists_of_message
              end
            end

            def build_missing_option
              result = "should be a collection "
              result += input_types.size > 1 ? "of #{input_types.join(', ')} types, " : "of type #{input_types.first}, "
              result += consists_of_types.size > 1 ? "consisting of the following types: " : "consisting of type "
              result += consists_of_types.join(", ")
              result + " with the message #{input_consists_of_message.inspect}"
            end
          end
        end
      end
    end
  end
end
