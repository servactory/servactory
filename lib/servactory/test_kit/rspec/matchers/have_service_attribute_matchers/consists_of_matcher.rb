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
              attribute_consists_of = attribute_data.fetch(:consists_of)
              attribute_consists_of_types = Array(attribute_consists_of.fetch(:type))
              attribute_consists_of_message = attribute_consists_of.fetch(:message)

              matched = attribute_consists_of_types.difference(consists_of_types).empty? &&
                        consists_of_types.difference(attribute_consists_of_types).empty?

              if !custom_message.nil? && !attribute_consists_of_message.nil?
                attribute_consists_of_message = attribute_consists_of_message.call if attribute_consists_of_message.is_a?(Proc)

                self.custom_message = custom_message.call if custom_message.is_a?(Proc)

                matched &&= attribute_consists_of_message.casecmp(custom_message).zero?
              end

              matched
            end

            def build_missing_option
              "should be consists_of"
            end
          end
        end
      end
    end
  end
end
