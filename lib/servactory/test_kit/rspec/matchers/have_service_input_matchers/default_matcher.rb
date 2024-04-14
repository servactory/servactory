# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Matchers
        module HaveServiceInputMatchers
          class DefaultMatcher
            attr_reader :missing_option

            def initialize(described_class, attribute_type, attribute_name, default_value)
              @described_class = described_class
              @attribute_type = attribute_type
              @attribute_type_plural = attribute_type.to_s.pluralize.to_sym
              @attribute_name = attribute_name
              @default_value = default_value

              @attribute_data = described_class.info.public_send(attribute_type_plural).fetch(attribute_name)

              @missing_option = ""
            end

            def description
              "default: #{default_value.inspect}"
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
                        :default_value,
                        :attribute_data

            def submatcher_passes?(_subject)
              attribute_default_value = attribute_data.fetch(:default)

              attribute_default_value.casecmp(default_value).zero?
            end

            def build_missing_option
              "should have a default value of #{default_value.inspect}"
            end
          end
        end
      end
    end
  end
end
