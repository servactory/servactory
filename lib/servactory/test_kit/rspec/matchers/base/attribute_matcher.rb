# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Matchers
        module Base
          # Base class for RSpec matchers that validate Servactory attribute definitions.
          #
          # ## Purpose
          #
          # AttributeMatcher provides the foundation for testing service attribute
          # definitions (inputs, internals, outputs) in Servactory services. It implements
          # the RSpec matcher protocol with fluent API for chaining validation rules.
          #
          # ## Usage
          #
          # Subclasses define specific attribute type matchers:
          #
          # ```ruby
          # class HaveServiceInputMatcher < Base::AttributeMatcher
          #   for_attribute_type :input
          #
          #   register_submatcher :required,
          #                       class_name: "Input::RequiredSubmatcher",
          #                       mutually_exclusive_with: [:optional]
          # end
          # ```
          #
          # In RSpec tests:
          #
          # ```ruby
          # expect(MyService).to have_service_input(:name)
          #   .type(String)
          #   .required
          #   .inclusion(%w[admin user])
          # ```
          #
          # ## Architecture
          #
          # Works with:
          # - SubmatcherRegistry - provides DSL for registering submatchers
          # - SubmatcherContext - carries context data to submatchers
          # - Submatcher - base class for individual validation rules
          #
          # ## Features
          #
          # - **Fluent API** - chain methods for readable test assertions
          # - **Dynamic Chain Methods** - generated from submatcher registry
          # - **Mutual Exclusivity** - conflicting options replace each other
          # - **Composable** - works with RSpec's compound matchers
          # - **Block Expectations** - supports `expect { }.to` syntax
          class AttributeMatcher # rubocop:disable Metrics/ClassLength
            include SubmatcherRegistry
            include RSpec::Matchers::Composable

            class << self
              # @return [Symbol] The attribute type this matcher validates (:input, :internal, :output)
              attr_reader :attribute_type

              # Sets the attribute type for this matcher class.
              #
              # @param type [Symbol] The attribute type (:input, :internal, :output)
              # @return [void]
              def for_attribute_type(type)
                @attribute_type = type
              end
            end

            # @return [Class] The Servactory service class being tested
            attr_reader :described_class

            # @return [Symbol] The name of the attribute being validated
            attr_reader :attribute_name

            # @return [Array, nil] Type classes passed to the types chain method
            attr_reader :option_types

            # Creates a new attribute matcher instance.
            #
            # @param described_class [Class] The Servactory service class to test
            # @param attribute_name [Symbol] The name of the attribute to validate
            def initialize(described_class, attribute_name)
              @described_class = described_class
              @attribute_name = attribute_name
              @submatchers = []
              @option_types = nil
              @last_submatcher = nil

              build_chain_methods_from_registry
            end

            # Indicates this matcher supports block expectations.
            #
            # Required by RSpec for matchers used with `expect { }.to` syntax.
            #
            # @return [Boolean] Always returns true
            def supports_block_expectations?
              true
            end

            # Checks if all submatchers pass for the given subject.
            #
            # @param subject [Object] The RSpec subject (typically nil for service class matchers)
            # @return [Boolean] True if all submatchers pass, false otherwise
            def matches?(subject)
              @subject = subject
              failing_submatchers.empty?
            end

            # Builds a human-readable description of what this matcher validates.
            #
            # @return [String] Description including attribute name and all submatcher descriptions
            def description
              submatcher_descriptions = submatchers.map(&:description).join(", ")
              "#{attribute_name} with #{submatcher_descriptions}"
            end

            # Builds the failure message when the matcher does not pass.
            #
            # @return [String] Explanation of what was expected and what was missing
            def failure_message
              "Expected #{expectation}, which #{missing_options}"
            end

            # Builds the failure message for negated expectations.
            #
            # @return [String] Explanation for negated expectation failure
            def failure_message_when_negated
              "Did not expect #{expectation} with specified options"
            end

            protected

            # @return [Array<Submatcher>] Collection of registered submatchers
            attr_reader :submatchers

            # @return [Object] The RSpec subject passed to matches?
            attr_reader :subject

            # @return [Submatcher, nil] The most recently added submatcher
            attr_reader :last_submatcher

            # Returns the attribute type from the class-level setting.
            #
            # @return [Symbol] The attribute type (:input, :internal, :output)
            def attribute_type
              self.class.attribute_type
            end

            # Returns the pluralized attribute type for accessing service info.
            #
            # @return [Symbol] Pluralized attribute type (:inputs, :internals, :outputs)
            def attribute_type_plural
              @attribute_type_plural ||= attribute_type.to_s.pluralize.to_sym
            end

            # Fetches attribute definition data from the service class.
            #
            # @return [Hash] The attribute definition hash from service info
            def attribute_data
              @attribute_data ||=
                described_class
                .info
                .public_send(attribute_type_plural)
                .fetch(attribute_name)
            end

            # Returns the i18n root key configured for the service.
            #
            # @return [String, nil] The i18n root key for error messages
            def i18n_root_key
              @i18n_root_key ||= described_class.config.i18n_root_key
            end

            # Builds the expectation string for failure messages.
            #
            # @return [String] Human-readable expectation description
            def expectation
              "#{described_class.name} to have a service #{attribute_type} attribute named #{attribute_name}"
            end

            # Finds submatchers that did not pass validation.
            #
            # @return [Array<Submatcher>] Submatchers where matches? returned false
            def failing_submatchers
              @failing_submatchers ||= submatchers.reject { |m| m.matches?(subject) }
            end

            # Collects missing option messages from failing submatchers.
            #
            # @return [String] Comma-separated list of missing option descriptions
            def missing_options
              failing_submatchers.map(&:missing_option).select(&:present?).join(", ")
            end

            # Adds a submatcher to the collection, replacing any of the same class.
            #
            # @param submatcher [Submatcher] The submatcher to add
            # @return [void]
            def add_submatcher(submatcher)
              remove_submatcher(submatcher.class)
              @last_submatcher = submatcher
              submatchers << submatcher
            end

            # Removes all submatchers of the specified class.
            #
            # @param matcher_class [Class] The submatcher class to remove
            # @return [void]
            def remove_submatcher(matcher_class)
              submatchers.delete_if { |sm| sm.is_a?(matcher_class) }
            end

            private

            # Dynamically defines chain methods from registered submatcher definitions.
            #
            # Called during initialization to create fluent API methods like
            # `.type()`, `.required()`, `.optional()`, etc.
            #
            # @return [void]
            def build_chain_methods_from_registry
              self.class.submatcher_definitions.each_value do |definition|
                define_chain_method_for(definition)
              end
            end

            # Defines a chain method and its aliases for a submatcher definition.
            #
            # Creates a singleton method that:
            # 1. Extracts options hash if applicable
            # 2. Removes mutually exclusive submatchers
            # 3. Stores option_types if needed
            # 4. Builds and adds the submatcher
            #
            # @param definition [SubmatcherDefinition] The submatcher definition
            # @return [void]
            def define_chain_method_for(definition) # rubocop:disable Metrics/MethodLength
              define_singleton_method(definition.chain_method) do |*args|
                # For methods that accept trailing options hash (like target(value, name: :option)),
                # we need to extract it. We use a heuristic: if the method expects options AND
                # the last arg is a Hash with Symbol keys that look like option keys.
                options = extract_options_hash(args, definition)

                handle_mutually_exclusive(definition)

                @option_types = definition.transform_args.call(args, options) if definition.stores_option_types

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

            # Extracts trailing options hash from arguments if the definition accepts them.
            #
            # @param args [Array] The method arguments
            # @param definition [SubmatcherDefinition] The submatcher definition
            # @return [Hash] Extracted options hash or empty hash
            def extract_options_hash(args, definition)
              # Only extract trailing options hash if the definition explicitly accepts them.
              return {} unless definition.accepts_trailing_options
              return {} unless args.last.is_a?(Hash)
              return {} if args.last.is_a?(Class)

              args.pop || {}
            end

            # Removes submatchers that are mutually exclusive with the current one.
            #
            # @param definition [SubmatcherDefinition] The current submatcher definition
            # @return [void]
            def handle_mutually_exclusive(definition)
              definition.mutually_exclusive_with.each do |exclusive_name|
                exclusive_def = self.class.submatcher_definitions[exclusive_name]
                next unless exclusive_def

                submatcher_class = resolve_submatcher_class(exclusive_def.class_name)
                remove_submatcher(submatcher_class)
              end
            end

            # Builds a submatcher instance with context and transformed arguments.
            #
            # @param definition [SubmatcherDefinition] The submatcher definition
            # @param args [Array] Original method arguments
            # @param options [Hash] Extracted options hash
            # @return [Submatcher] The constructed submatcher instance
            def build_submatcher(definition, args, options) # rubocop:disable Metrics/MethodLength
              context = SubmatcherContext.new(
                described_class:,
                attribute_type:,
                attribute_name:,
                attribute_data:,
                option_types: definition.requires_option_types ? option_types : nil,
                last_submatcher: definition.requires_last_submatcher ? last_submatcher : nil,
                i18n_root_key:
              )

              transformed_args = definition.transform_args.call(args, options)
              submatcher_class = resolve_submatcher_class(definition.class_name)
              submatcher_class.new(context, *transformed_args)
            end

            # Resolves submatcher class name to actual class constant.
            #
            # @param class_name [String] Relative class name (e.g., "Input::RequiredSubmatcher")
            # @return [Class] The submatcher class
            def resolve_submatcher_class(class_name)
              "Servactory::TestKit::Rspec::Matchers::Submatchers::#{class_name}".constantize
            end
          end
        end
      end
    end
  end
end
