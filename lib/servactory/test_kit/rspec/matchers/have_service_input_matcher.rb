# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Matchers
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
            transform_args: ->(args, _kwargs = {}) { [Array(args.first)] }

          register_submatcher :must,
            class_name: "Shared::MustSubmatcher",
            transform_args: ->(args, _kwargs = {}) { [Array(args).flatten] }

          register_submatcher :message,
            class_name: "Shared::MessageSubmatcher",
            transform_args: ->(args, _kwargs = {}) { [args.first] },
            requires_last_submatcher: true

          register_submatcher :target,
            class_name: "Shared::TargetSubmatcher",
            transform_args: ->(args, kwargs = {}) { [kwargs.fetch(:name, :target), Array(args.first)] },
            accepts_trailing_options: true

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
