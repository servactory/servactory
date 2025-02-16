# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Matchers
        module HaveServiceAttributeMatchers
          class InclusionMatcher
            attr_reader :missing_option

            def initialize(described_class, attribute_type, attribute_name, values, custom_message)
              @described_class = described_class
              @attribute_type = attribute_type
              @attribute_type_plural = attribute_type.to_s.pluralize.to_sym
              @attribute_name = attribute_name
              @values = values
              # TODO: Need to implement it. There should be support for `be_a(Proc)`.
              @custom_message = custom_message

              @attribute_data = described_class.info.public_send(attribute_type_plural).fetch(attribute_name)

              @missing_option = ""
            end

            def description
              "inclusion: #{values.join(', ')}"
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
                        :values,
                        :custom_message,
                        :attribute_data

            def submatcher_passes?(_subject) # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
              attribute_inclusion = attribute_data.fetch(:inclusion)
              attribute_inclusion_in = attribute_inclusion.fetch(:in)
              attribute_inclusion_message = attribute_inclusion.fetch(:message)

              matched = attribute_inclusion_in.difference(values).empty? &&
                        values.difference(attribute_inclusion_in).empty?

              if custom_message.present? && !attribute_inclusion_message.nil?
                if custom_message.is_a?(RSpec::Matchers::BuiltIn::BaseMatcher)
                  RSpec::Expectations::ExpectationTarget.for(attribute_inclusion_message, nil).to custom_message
                else
                  matched &&= attribute_inclusion_message.casecmp(custom_message).zero?
                end
              end

              matched
            end

            def build_missing_option
              attribute_inclusion = attribute_data.fetch(:inclusion)
              attribute_inclusion_in = attribute_inclusion.fetch(:in)

              <<~MESSAGE
                should include the expected values

                  expected #{values.inspect}
                       got #{attribute_inclusion_in.inspect}
              MESSAGE
            end
          end
        end
      end
    end
  end
end
