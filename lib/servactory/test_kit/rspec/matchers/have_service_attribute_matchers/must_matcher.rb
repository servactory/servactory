# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Matchers
        module HaveServiceAttributeMatchers
          class MustMatcher
            attr_reader :missing_option

            def initialize(described_class, attribute_type, attribute_name, must_names)
              @described_class = described_class
              @attribute_type = attribute_type
              @attribute_type_plural = attribute_type.to_s.pluralize.to_sym
              @attribute_name = attribute_name
              @must_names = must_names

              @attribute_data = described_class.info.public_send(attribute_type_plural).fetch(attribute_name)

              @missing_option = ""
            end

            def description
              "must: #{must_names.join(', ')}"
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
                        :must_names,
                        :attribute_data

            def submatcher_passes?(_subject)
              attribute_must = attribute_data.fetch(:must)

              attribute_must.keys.difference(must_names).empty? &&
                must_names.difference(attribute_must.keys).empty?
            end

            def build_missing_option
              "should #{must_names.join(', ')}"
            end
          end
        end
      end
    end
  end
end
