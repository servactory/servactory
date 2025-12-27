# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Matchers
        module Submatchers
          module Shared
            class ConsistsOfSubmatcher < Base::Submatcher
              OPTION_NAME = :consists_of
              OPTION_BODY_KEY = :type

              def initialize(context, consists_of_types)
                super(context)
                @consists_of_types = consists_of_types
              end

              def description
                "consists_of: #{consists_of_types.map(&:name).join(', ')}"
              end

              protected

              def passes?
                attribute_consists_of = attribute_data.fetch(OPTION_NAME)
                @actual_types = Array(attribute_consists_of.fetch(OPTION_BODY_KEY))

                @actual_types.difference(consists_of_types).empty? &&
                  consists_of_types.difference(@actual_types).empty?
              end

              def build_failure_message
                <<~MESSAGE
                  should be consists_of #{consists_of_types.map(&:name).join(', ')}

                    expected #{consists_of_types.inspect}
                         got #{@actual_types.inspect}
                MESSAGE
              end

              private

              attr_reader :consists_of_types
            end
          end
        end
      end
    end
  end
end
