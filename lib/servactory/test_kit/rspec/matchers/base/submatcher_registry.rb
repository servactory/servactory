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

              def register_submatcher(name, options = {})
                submatcher_definitions[name] = SubmatcherDefinition.new(
                  name: name,
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

            SubmatcherDefinition = Struct.new(
              :name, :class_name, :chain_method, :chain_aliases,
              :transform_args, :requires_option_types,
              :requires_last_submatcher, :mutually_exclusive_with,
              :stores_option_types, :accepts_trailing_options,
              keyword_init: true
            )
          end
        end
      end
    end
  end
end
