# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Matchers
        module HaveServiceAttributeMatchers
          class ConsistsOfMatcher
            attr_reader :missing_option

            def initialize(described_class, attribute_type, attribute_name, option_types, consists_of_types,
                           custom_message)
              @described_class = described_class
              @attribute_type = attribute_type
              @attribute_type_plural = attribute_type.to_s.pluralize.to_sym
              @attribute_name = attribute_name
              @option_types = option_types
              @consists_of_types = consists_of_types
              @custom_message = custom_message

              @attribute_data = described_class.info.public_send(attribute_type_plural).fetch(attribute_name)

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

            attr_reader :described_class,
                        :attribute_type,
                        :attribute_type_plural,
                        :attribute_name,
                        :option_types,
                        :consists_of_types,
                        :custom_message,
                        :attribute_data

            def submatcher_passes?(_subject)
              attribute_consists_of = Array(attribute_data.fetch(:consists_of).fetch(:type) || [])

              matched = attribute_consists_of.difference(consists_of_types).empty?

              matched &&= attribute_consists_of_message.casecmp(custom_message).zero? if custom_message.present?

              matched
            end

            def attribute_consists_of_message # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
              attribute_consists_of_message = attribute_data.fetch(:consists_of).fetch(:message)

              if attribute_consists_of_message.nil?
                I18n.t(
                  "servactory.#{attribute_type_plural}.validations.required.default_error.for_collection",
                  service_class_name: described_class.name,
                  "#{attribute_type}_name": attribute_name
                )
              elsif attribute_consists_of_message.is_a?(Proc)
                input_work = attribute_data.fetch(:work)

                attribute_consists_of_message.call(
                  input: input_work,
                  expected_type: String,
                  given_type: Servactory::TestKit::FakeType.new.class.name
                )
              else
                attribute_consists_of_message
              end
            end

            def build_missing_option
              result = "should be a collection "
              result += option_types.size > 1 ? "of #{option_types.join(', ')} types, " : "of type #{option_types.first}, " # rubocop:disable Layout/LineLength
              result += consists_of_types.size > 1 ? "consisting of the following types: " : "consisting of type "
              result += consists_of_types.join(", ")
              result + " with the message #{attribute_consists_of_message.inspect}"
            end
          end
        end
      end
    end
  end
end
