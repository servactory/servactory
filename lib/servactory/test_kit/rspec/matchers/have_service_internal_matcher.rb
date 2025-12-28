# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Matchers
        # RSpec matcher for validating Servactory service internal definitions.
        #
        # ## Purpose
        #
        # Validates that a service class has the expected internal attribute with
        # specified type, schema, and other options. Internal attributes are used
        # for intermediate values during service execution.
        #
        # ## Usage
        #
        # ```ruby
        # RSpec.describe MyService, type: :service do
        #   it { is_expected.to have_service_internal(:processed_data).type(Hash) }
        #   it { is_expected.to have_service_internal(:items).type(Array).consists_of(Item) }
        #   it { is_expected.to have_service_internal(:config).schema({ key: String }) }
        # end
        # ```
        #
        # ## Chain Methods
        #
        # - `.type(Class)` / `.types(Class, ...)` - expected type(s)
        # - `.consists_of(Class)` - for Array/Hash element types
        # - `.schema(Hash)` - expected schema definition
        # - `.inclusion(Array)` - expected inclusion values
        # - `.must(Array)` - custom validation rules
        # - `.target(value, name:)` - target validation
        # - `.message(String)` - expected error message (after other chain)
        #
        # ## Architecture
        #
        # Inherits from Base::AttributeMatcher with `for_attribute_type :internal`.
        # Uses shared submatchers for common validations.
        class HaveServiceInternalMatcher < Base::AttributeMatcher
          for_attribute_type :internal

          # Shared submatchers
          register_submatcher :types,
                              class_name: "Shared::TypesSubmatcher",
                              chain_method: :type,
                              chain_aliases: [:types],
                              transform_args: ->(args, _kwargs = {}) { [Array(args).flatten] },
                              stores_option_types: true

          register_submatcher :consists_of,
                              class_name: "Shared::ConsistsOfSubmatcher",
                              transform_args: ->(args, _kwargs = {}) { [Array(args).flatten] },
                              requires_option_types: true

          register_submatcher :schema,
                              class_name: "Shared::SchemaSubmatcher",
                              transform_args: ->(args, _kwargs = {}) { [args.first || {}] },
                              requires_option_types: true

          register_submatcher :inclusion,
                              class_name: "Shared::InclusionSubmatcher",
                              transform_args: ->(args, _kwargs = {}) { [Array(args.first)] }

          register_submatcher :target,
                              class_name: "Shared::TargetSubmatcher",
                              transform_args: (lambda do |args, kwargs = {}|
                                [kwargs.fetch(:name, :target), Array(args.first)]
                              end),
                              accepts_trailing_options: true

          register_submatcher :must,
                              class_name: "Shared::MustSubmatcher",
                              transform_args: ->(args, _kwargs = {}) { [Array(args).flatten] }

          register_submatcher :message,
                              class_name: "Shared::MessageSubmatcher",
                              transform_args: ->(args, _kwargs = {}) { [args.first] },
                              requires_last_submatcher: true
        end
      end
    end
  end
end
