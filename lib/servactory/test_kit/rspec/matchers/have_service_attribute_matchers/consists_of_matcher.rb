# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Matchers
        module HaveServiceAttributeMatchers
          class ConsistsOfMatcher
            OPTION_NAME = :consists_of
            OPTION_BODY_KEY = :type

            attr_reader :missing_option

            def initialize(described_class, attribute_type, attribute_name, option_types, consists_of_types)
              @described_class = described_class
              @attribute_type = attribute_type
              @attribute_type_plural = attribute_type.to_s.pluralize.to_sym
              @attribute_name = attribute_name
              @option_types = option_types
              @consists_of_types = consists_of_types

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
                        :attribute_data

            def submatcher_passes?(_subject)
              attribute_consists_of = attribute_data.fetch(OPTION_NAME)
              attribute_consists_of_types = Array(attribute_consists_of.fetch(OPTION_BODY_KEY))

              attribute_consists_of_types.difference(consists_of_types).empty? &&
                consists_of_types.difference(attribute_consists_of_types).empty?
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
