# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Matchers
        # RSpec matcher for validating Servactory service input definitions.
        #
        # ## Purpose
        #
        # Validates that a service class has the expected input attribute with
        # specified type, required status, defaults, and other options.
        #
        # ## Usage
        #
        # ```ruby
        # RSpec.describe MyService, type: :service do
        #   it { is_expected.to have_service_input(:user_id).type(Integer).required }
        #   it { is_expected.to have_service_input(:name).type(String).optional }
        #   it { is_expected.to have_service_input(:age).type(Integer).default(18) }
        #   it { is_expected.to have_service_input(:status).inclusion(%w[active inactive]) }
        # end
        # ```
        #
        # ## Chain Methods
        #
        # - `.type(Class)` / `.types(Class, ...)` - expected type(s)
        # - `.required` / `.optional` - required status
        # - `.default(value)` - expected default value
        # - `.consists_of(Class)` - for Array/Hash element types
        # - `.schema(Hash)` - expected schema definition
        # - `.inclusion(Array)` - expected inclusion values
        # - `.must(Array)` - custom validation rules
        # - `.target(value, name:)` - target validation
        # - `.message(String)` - expected error message (after other chain)
        class HaveServiceInputMatcher < Base::AttributeMatcher
          for_attribute_type :input

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
                              transform_args: ->(args, _kwargs = {}) { [args.first.is_a?(Range) ? args.first : Array(args.first)] }

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

          # Input-specific submatchers
          register_submatcher :required,
                              class_name: "Input::RequiredSubmatcher",
                              transform_args: ->(args, _kwargs = {}) { [args.first] },
                              mutually_exclusive_with: [:optional]

          register_submatcher :optional,
                              class_name: "Input::OptionalSubmatcher",
                              mutually_exclusive_with: [:required]

          register_submatcher :default,
                              class_name: "Input::DefaultSubmatcher",
                              transform_args: ->(args, _kwargs = {}) { [args.first] }

          register_submatcher :valid_with,
                              class_name: "Input::ValidWithSubmatcher",
                              transform_args: ->(args, _kwargs = {}) { [args.first] }
        end
      end
    end
  end
end
