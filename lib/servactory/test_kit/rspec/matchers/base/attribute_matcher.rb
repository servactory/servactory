# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Matchers
        module Base
          class AttributeMatcher
            include SubmatcherRegistry
            include RSpec::Matchers::Composable

            class << self
              attr_reader :attribute_type

              def for_attribute_type(type)
                @attribute_type = type
              end
            end

            attr_reader :described_class, :attribute_name, :option_types

            def initialize(described_class, attribute_name)
              @described_class = described_class
              @attribute_name = attribute_name
              @submatchers = []
              @option_types = nil
              @last_submatcher = nil

              build_chain_methods_from_registry
            end

            def supports_block_expectations?
              true
            end

            def matches?(subject)
              @subject = subject
              failing_submatchers.empty?
            end

            def description
              submatcher_descriptions = submatchers.map(&:description).join(", ")
              "#{attribute_name} with #{submatcher_descriptions}"
            end

            def failure_message
              "Expected #{expectation}, which #{missing_options}"
            end

            def failure_message_when_negated
              "Did not expect #{expectation} with specified options"
            end

            protected

            attr_reader :submatchers, :subject, :last_submatcher

            def attribute_type
              self.class.attribute_type
            end

            def attribute_type_plural
              @attribute_type_plural ||= attribute_type.to_s.pluralize.to_sym
            end

            def attribute_data
              @attribute_data ||= described_class.info
                .public_send(attribute_type_plural)
                .fetch(attribute_name)
            end

            def i18n_root_key
              @i18n_root_key ||= described_class.config.i18n_root_key
            end

            def expectation
              "#{described_class.name} to have a service #{attribute_type} attribute named #{attribute_name}"
            end

            def failing_submatchers
              @failing_submatchers ||= submatchers.reject { |m| m.matches?(subject) }
            end

            def missing_options
              failing_submatchers.map(&:missing_option).select(&:present?).join(", ")
            end

            def add_submatcher(submatcher)
              remove_submatcher(submatcher.class)
              @last_submatcher = submatcher
              submatchers << submatcher
            end

            def remove_submatcher(matcher_class)
              submatchers.delete_if { |sm| sm.is_a?(matcher_class) }
            end

            private

            def build_chain_methods_from_registry
              self.class.submatcher_definitions.each_value do |definition|
                define_chain_method_for(definition)
              end
            end

            def define_chain_method_for(definition) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
              define_singleton_method(definition.chain_method) do |*args|
                # For methods that accept trailing options hash (like target(value, name: :option)),
                # we need to extract it. We use a heuristic: if the method expects options AND
                # the last arg is a Hash with Symbol keys that look like option keys.
                options = extract_options_hash(args, definition)

                handle_mutually_exclusive(definition)

                if definition.stores_option_types
                  @option_types = definition.transform_args.call(args, options)
                end

                submatcher = build_submatcher(definition, args, options)
                add_submatcher(submatcher)
                self
              end

              definition.chain_aliases.each do |alias_name|
                define_singleton_method(alias_name) do |*args|
                  public_send(definition.chain_method, *args)
                end
              end
            end

            def extract_options_hash(args, definition)
              # Only extract trailing options hash if the definition explicitly accepts them
              return {} unless definition.accepts_trailing_options
              return {} unless args.last.is_a?(Hash)
              return {} if args.last.is_a?(Class)

              args.pop
            end

            def handle_mutually_exclusive(definition)
              definition.mutually_exclusive_with.each do |exclusive_name|
                exclusive_def = self.class.submatcher_definitions[exclusive_name]
                next unless exclusive_def

                submatcher_class = resolve_submatcher_class(exclusive_def.class_name)
                remove_submatcher(submatcher_class)
              end
            end

            def build_submatcher(definition, args, options) # rubocop:disable Metrics/MethodLength
              context = SubmatcherContext.new(
                described_class: described_class,
                attribute_type: attribute_type,
                attribute_name: attribute_name,
                attribute_data: attribute_data,
                option_types: definition.requires_option_types ? option_types : nil,
                last_submatcher: definition.requires_last_submatcher ? last_submatcher : nil,
                i18n_root_key: i18n_root_key
              )

              transformed_args = definition.transform_args.call(args, options)
              submatcher_class = resolve_submatcher_class(definition.class_name)
              submatcher_class.new(context, *transformed_args)
            end

            def resolve_submatcher_class(class_name)
              "Servactory::TestKit::Rspec::Matchers::Submatchers::#{class_name}".constantize
            end
          end
        end
      end
    end
  end
end
