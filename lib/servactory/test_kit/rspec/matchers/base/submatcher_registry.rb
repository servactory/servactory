# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Matchers
        module Base
          # Registry mixin providing DSL for registering submatchers in attribute matchers.
          #
          # ## Purpose
          #
          # SubmatcherRegistry provides a class-level DSL for declaratively registering
          # submatchers in AttributeMatcher subclasses. It handles inheritance of
          # submatcher definitions and configuration options for each submatcher.
          #
          # ## Usage
          #
          # Include this module in AttributeMatcher subclasses:
          #
          # ```ruby
          # class HaveServiceInputMatcher < Base::AttributeMatcher
          #   include SubmatcherRegistry
          #
          #   register_submatcher :required,
          #                       class_name: "Input::RequiredSubmatcher",
          #                       mutually_exclusive_with: [:optional]
          #
          #   register_submatcher :types,
          #                       class_name: "Shared::TypesSubmatcher",
          #                       chain_method: :type,
          #                       chain_aliases: [:types],
          #                       stores_option_types: true
          # end
          # ```
          #
          # ## Features
          #
          # - **Declarative Registration** - register submatchers with options hash
          # - **Chain Method Generation** - creates fluent API methods automatically
          # - **Inheritance Support** - subclasses inherit parent's submatcher definitions
          # - **Argument Transformation** - customize how arguments are passed to submatchers
          # - **Mutual Exclusivity** - define conflicting submatchers that replace each other
          #
          # ## Architecture
          #
          # Works with:
          # - AttributeMatcher - uses registry to build chain methods
          # - SubmatcherDefinition - holds configuration for each submatcher
          # - Submatcher - base class for actual validation logic
          module SubmatcherRegistry
            # Extends the including class with ClassMethods.
            #
            # @param base [Class] The class including this module
            # @return [void]
            def self.included(base)
              base.extend(ClassMethods)
            end

            # Class methods added to the including class.
            module ClassMethods
              # Returns the hash of registered submatcher definitions.
              #
              # @return [Hash{Symbol => SubmatcherDefinition}] Submatcher definitions by name
              def submatcher_definitions
                @submatcher_definitions ||= {}
              end

              # Registers a new submatcher with configuration options.
              #
              # ## Options
              #
              # - `:class_name` - Relative class path (e.g., "Input::RequiredSubmatcher")
              # - `:chain_method` - Method name for fluent API (defaults to name)
              # - `:chain_aliases` - Additional method names that call chain_method
              # - `:transform_args` - Lambda to transform method args before passing to submatcher
              # - `:requires_option_types` - Pass option_types to submatcher context
              # - `:requires_last_submatcher` - Pass previous submatcher to context
              # - `:mutually_exclusive_with` - Array of submatcher names to remove when this is added
              # - `:stores_option_types` - Store transformed args as option_types
              # - `:accepts_trailing_options` - Extract trailing hash as keyword arguments
              #
              # @param name [Symbol] Unique identifier for this submatcher
              # @param options [Hash] Configuration options
              # @return [SubmatcherDefinition] The created definition
              def register_submatcher(name, options = {}) # rubocop:disable Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
                submatcher_definitions[name] = SubmatcherDefinition.new(
                  name:,
                  class_name: options[:class_name],
                  chain_method: options[:chain_method] || name,
                  chain_aliases: options[:chain_aliases] || [],
                  transform_args: options[:transform_args] || ->(args, _kwargs = {}) { args },
                  requires_option_types: options[:requires_option_types] || false,
                  requires_last_submatcher: options[:requires_last_submatcher] || false,
                  mutually_exclusive_with: options[:mutually_exclusive_with] || [],
                  stores_option_types: options[:stores_option_types] || false,
                  accepts_trailing_options: options[:accepts_trailing_options] || false
                )
              end

              # Copies submatcher definitions to subclasses.
              #
              # @param subclass [Class] The inheriting class
              # @return [void]
              def inherited(subclass)
                super
                subclass.instance_variable_set(
                  :@submatcher_definitions,
                  submatcher_definitions.dup
                )
              end
            end

            # Value object holding configuration for a single submatcher registration.
            #
            # ## Purpose
            #
            # Encapsulates all configuration options for a submatcher, including
            # how to generate chain methods, transform arguments, and handle
            # mutual exclusivity with other submatchers.
            #
            # ## Attributes
            #
            # - `name` - Unique identifier for this submatcher
            # - `class_name` - Relative path to submatcher class
            # - `chain_method` - Name of the fluent API method
            # - `chain_aliases` - Alternative method names
            # - `transform_args` - Lambda for argument transformation
            # - `requires_option_types` - Whether submatcher needs type information
            # - `requires_last_submatcher` - Whether submatcher needs previous submatcher
            # - `mutually_exclusive_with` - Conflicting submatcher names
            # - `stores_option_types` - Whether to store args as option_types
            # - `accepts_trailing_options` - Whether to extract trailing hash
            class SubmatcherDefinition
              # @return [Symbol] Unique identifier for this submatcher
              attr_reader :name

              # @return [String] Relative class path (e.g., "Input::RequiredSubmatcher")
              attr_reader :class_name

              # @return [Symbol] Method name for the fluent API
              attr_reader :chain_method

              # @return [Array<Symbol>] Alternative method names
              attr_reader :chain_aliases

              # @return [Proc] Lambda to transform arguments
              attr_reader :transform_args

              # @return [Boolean] Whether submatcher needs option_types in context
              attr_reader :requires_option_types

              # @return [Boolean] Whether submatcher needs last_submatcher in context
              attr_reader :requires_last_submatcher

              # @return [Array<Symbol>] Names of mutually exclusive submatchers
              attr_reader :mutually_exclusive_with

              # @return [Boolean] Whether to store transformed args as option_types
              attr_reader :stores_option_types

              # @return [Boolean] Whether to extract trailing hash as options
              attr_reader :accepts_trailing_options

              # Creates a new submatcher definition.
              #
              # @param name [Symbol] Unique identifier
              # @param class_name [String] Relative class path
              # @param chain_method [Symbol] Fluent API method name
              # @param chain_aliases [Array<Symbol>] Alternative method names
              # @param transform_args [Proc] Argument transformation lambda
              # @param requires_option_types [Boolean] Pass option_types to context
              # @param requires_last_submatcher [Boolean] Pass last_submatcher to context
              # @param mutually_exclusive_with [Array<Symbol>] Conflicting submatchers
              # @param stores_option_types [Boolean] Store args as option_types
              # @param accepts_trailing_options [Boolean] Extract trailing hash
              def initialize(
                name:,
                class_name:,
                chain_method: nil,
                chain_aliases: nil,
                transform_args: nil,
                requires_option_types: false,
                requires_last_submatcher: false,
                mutually_exclusive_with: nil,
                stores_option_types: false,
                accepts_trailing_options: false
              )
                @name = name
                @class_name = class_name
                @chain_method = chain_method
                @chain_aliases = chain_aliases
                @transform_args = transform_args
                @requires_option_types = requires_option_types
                @requires_last_submatcher = requires_last_submatcher
                @mutually_exclusive_with = mutually_exclusive_with
                @stores_option_types = stores_option_types
                @accepts_trailing_options = accepts_trailing_options
              end
            end
          end
        end
      end
    end
  end
end
