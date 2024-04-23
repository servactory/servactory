# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Matchers
        module HaveServiceInputMatchers
          class OptionalMatcher
            attr_reader :missing_option

            def initialize(described_class, attribute_type, attribute_name)
              @described_class = described_class
              @attribute_type = attribute_type
              @attribute_type_plural = attribute_type.to_s.pluralize.to_sym
              @attribute_name = attribute_name

              @attribute_data = described_class.info.public_send(attribute_type_plural).fetch(attribute_name)

              @missing_option = ""
            end

            def description
              "required: false"
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
                        :attribute_data

            def submatcher_passes?(_subject)
              input_required = attribute_data.fetch(:required).fetch(:is)

              input_required == false
            end

            def build_missing_option
              <<~MESSAGE
                should be optional

                  expected required: false
                       got required: true
              MESSAGE
            end
          end
        end
      end
    end
  end
end
