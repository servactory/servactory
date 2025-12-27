# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Matchers
        module Base
          module SubmatcherRegistry
            def self.included(base)
              base.extend(ClassMethods)
            end

            module ClassMethods
              def submatcher_definitions
                @submatcher_definitions ||= {}
              end

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

              def inherited(subclass)
                super
                subclass.instance_variable_set(
                  :@submatcher_definitions,
                  submatcher_definitions.dup
                )
              end
            end

            class SubmatcherDefinition
              attr_reader :name,
                          :class_name,
                          :chain_method,
                          :chain_aliases,
                          :transform_args,
                          :requires_option_types,
                          :requires_last_submatcher,
                          :mutually_exclusive_with,
                          :stores_option_types,
                          :accepts_trailing_options

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
