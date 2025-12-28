# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Matchers
        module Submatchers
          module Shared
            # Submatcher for validating custom `must` validation rules.
            #
            # ## Purpose
            #
            # Validates that an attribute has the expected custom validation rules
            # defined via the `must` option. Excludes dynamic options that are
            # tested separately (consists_of, schema, be_inclusion, be_target).
            #
            # ## Usage
            #
            # ```ruby
            # it { is_expected.to have_service_input(:email).must([:be_valid_email]) }
            # it { is_expected.to have_service_input(:age).must([:be_positive, :be_adult]) }
            # ```
            #
            # ## Comparison
            #
            # Uses set difference to compare validation names - order doesn't matter.
            class MustSubmatcher < Base::Submatcher
              # Creates a new must submatcher.
              #
              # @param context [Base::SubmatcherContext] The submatcher context
              # @param must_names [Array<Symbol>] Expected validation rule names
              # @return [MustSubmatcher] New submatcher instance
              def initialize(context, must_names)
                super(context)
                @must_names = must_names
              end

              # Returns description for RSpec output.
              #
              # @return [String] Human-readable description with rule names
              def description
                "must: #{must_names.join(', ')}"
              end

              protected

              # Checks if the must rules match expected rules.
              #
              # Filters out dynamic options that are tested by other submatchers.
              #
              # @return [Boolean] True if must rules match (order-independent)
              def passes?
                attribute_must = attribute_data.fetch(:must)
                attribute_must_keys = attribute_must.keys.dup

                # NOTE: Dynamic options that are also `must` but tested separately
                attribute_must_keys.delete(:consists_of)
                attribute_must_keys.delete(:schema)
                attribute_must_keys.delete(:be_inclusion)
                attribute_must_keys.delete(:be_target)

                attribute_must_keys.difference(must_names).empty? &&
                  must_names.difference(attribute_must_keys).empty?
              end

              # Builds the failure message for must validation.
              #
              # @return [String] Simple failure message with expected rules
              def build_failure_message
                "should #{must_names.join(', ')}"
              end

              private

              attr_reader :must_names
            end
          end
        end
      end
    end
  end
end
