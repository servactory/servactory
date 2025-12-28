# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Matchers
        module Submatchers
          module Shared
            # Submatcher for validating Array/Hash element types.
            #
            # ## Purpose
            #
            # Validates that an Array or Hash attribute specifies the expected
            # element types via the `consists_of` option. Used with collection
            # attributes to verify their content type constraints.
            #
            # ## Usage
            #
            # ```ruby
            # it { is_expected.to have_service_input(:items).type(Array).consists_of(Item) }
            # it { is_expected.to have_service_input(:users).type(Array).consists_of(User, Admin) }
            # it { is_expected.to have_service_internal(:data).type(Hash).consists_of(String) }
            # ```
            #
            # ## Note
            #
            # Requires the `:types` option to be set first (via `.type` chain).
            class ConsistsOfSubmatcher < Base::Submatcher
              # Option name in attribute data
              OPTION_NAME = :consists_of
              # Key for the type value within the option
              OPTION_BODY_KEY = :type

              # Creates a new consists_of submatcher.
              #
              # @param context [Base::SubmatcherContext] The submatcher context
              # @param consists_of_types [Array<Class>] Expected element types
              # @return [ConsistsOfSubmatcher] New submatcher instance
              def initialize(context, consists_of_types)
                super(context)
                @consists_of_types = consists_of_types
              end

              # Returns description for RSpec output.
              #
              # @return [String] Human-readable description with element types
              def description
                "consists_of: #{consists_of_types.map(&:name).join(', ')}"
              end

              protected

              # Checks if the element types match expected types.
              #
              # @return [Boolean] True if element types match (order-independent)
              def passes?
                attribute_consists_of = attribute_data.fetch(OPTION_NAME)
                @actual_types = Array(attribute_consists_of.fetch(OPTION_BODY_KEY))

                @actual_types.difference(consists_of_types).empty? &&
                  consists_of_types.difference(@actual_types).empty?
              end

              # Builds the failure message for consists_of validation.
              #
              # @return [String] Failure message with expected vs actual types
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
