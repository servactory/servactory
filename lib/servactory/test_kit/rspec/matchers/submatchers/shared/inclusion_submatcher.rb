# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Matchers
        module Submatchers
          module Shared
            class InclusionSubmatcher < Base::Submatcher
              OPTION_NAME = :inclusion
              OPTION_BODY_KEY = :in

              def initialize(context, values)
                super(context)
                @values = values
              end

              def description
                "inclusion: #{values.join(', ')}"
              end

              protected

              def passes?
                return false unless attribute_inclusion.is_a?(Hash)
                return false if attribute_inclusion_in.nil?

                attribute_inclusion_in.difference(values).empty? &&
                  values.difference(attribute_inclusion_in).empty?
              end

              def build_failure_message
                <<~MESSAGE
                  should include the expected values

                    expected #{values.inspect}
                         got #{attribute_inclusion_in.inspect}
                MESSAGE
              end

              private

              attr_reader :values

              def attribute_inclusion
                @attribute_inclusion ||= attribute_data[OPTION_NAME]
              end

              def attribute_inclusion_in
                return @attribute_inclusion_in if defined?(@attribute_inclusion_in)

                @attribute_inclusion_in = attribute_inclusion&.dig(OPTION_BODY_KEY)
              end
            end
          end
        end
      end
    end
  end
end
