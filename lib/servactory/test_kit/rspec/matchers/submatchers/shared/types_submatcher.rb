# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Matchers
        module Submatchers
          module Shared
            class TypesSubmatcher < Base::Submatcher
              def initialize(context, expected_types)
                super(context)
                @expected_types = expected_types
              end

              def description
                "type(s): #{expected_types.map(&:name).join(', ')}"
              end

              protected

              def passes?
                actual_types = attribute_data.fetch(:types)
                @actual_types = actual_types

                expected_types.sort_by(&:name) == actual_types.sort_by(&:name)
              end

              def build_failure_message
                <<~MESSAGE.squish
                  should have type(s) #{expected_types.map(&:name).join(', ')}
                  but got #{@actual_types.map(&:name).join(', ')}
                MESSAGE
              end

              private

              attr_reader :expected_types
            end
          end
        end
      end
    end
  end
end
