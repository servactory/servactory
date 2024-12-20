# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Matchers
        module HaveServiceAttributeMatchers
          class NoteMatcher
            attr_reader :missing_option

            def initialize(described_class, attribute_type, attribute_name, note)
              @described_class = described_class
              @attribute_type = attribute_type
              @attribute_type_plural = attribute_type.to_s.pluralize.to_sym
              @attribute_name = attribute_name
              @note = note

              @attribute_data = described_class.info.public_send(attribute_type_plural).fetch(attribute_name)

              @missing_option = ""
            end

            def description
              "note: #{note}"
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
                        :note,
                        :attribute_data

            def submatcher_passes?(_subject)
              attribute_note = attribute_data.fetch(:note)

              attribute_note == note
            end

            def build_missing_option
              attribute_note = attribute_data.fetch(:note)

              <<~MESSAGE
                should have a note

                  expected #{note.inspect}
                       got #{attribute_note.inspect}
              MESSAGE
            end
          end
        end
      end
    end
  end
end
