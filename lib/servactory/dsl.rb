# frozen_string_literal: true

module Servactory
  module DSL
    module Extensions
      def self.registry
        @registry ||= []
      end

      def self.register(*extensions)
        registry.concat(extensions)
      end

      def self.clear
        @registry = []
      end
    end

    module Hooks
      VALID_HOOK_POINTS = %i[before_actions after_actions around_actions on_failure].freeze

      class Registry
        def initialize
          @hooks = VALID_HOOK_POINTS.to_h { |point| [point, []] }
        end

        def register(hook_point, handler = nil, priority: 0, &block)
          raise ArgumentError, "Invalid hook: #{hook_point}" unless VALID_HOOK_POINTS.include?(hook_point)

          @hooks[hook_point] << HookEntry.new(handler: handler || block, priority: priority)
        end

        def hooks_for(hook_point)
          @hooks.fetch(hook_point, []).sort_by(&:priority)
        end

        def dup_for_inheritance
          dup.tap do |copy|
            copy.instance_variable_set(:@hooks, @hooks.transform_values { |entries| entries.map(&:dup) })
          end
        end
      end

      class HookEntry
        attr_reader :handler, :priority

        def initialize(handler:, priority:)
          @handler = handler
          @priority = priority
        end

        def call(context, **options)
          if handler.is_a?(Symbol)
            context.send(handler, **options)
          else
            context.instance_exec(**options, &handler)
          end
        end

        def dup
          self.class.new(handler: handler, priority: priority)
        end
      end

      class Runner
        def initialize(context)
          @context = context
        end

        def run_before_actions
          run_hooks(:before_actions)
        end

        def run_after_actions
          run_hooks(:after_actions)
        end

        def run_around_actions(&block)
          around_hooks = @context.class.hooks_registry.hooks_for(:around_actions)
          return yield if around_hooks.empty?

          around_hooks.reverse.reduce(block) { |inner, hook|
            -> { hook.call(@context, proceed: inner) }
          }.call
        end

        def run_on_failure(exception)
          run_hooks(:on_failure, exception: exception)
        end

        private

        def run_hooks(hook_point, **options)
          @context.class.hooks_registry.hooks_for(hook_point).each do |hook|
            hook.call(@context, **options)
          end
        end
      end
    end

    module HooksIntegration
      def self.included(base)
        base.extend(ClassMethods)
        base.include(InstanceMethods)
      end

      module ClassMethods
        def inherited(child)
          super
          child.instance_variable_set(:@hooks_registry, hooks_registry.dup_for_inheritance)
        end

        def hooks_registry
          @hooks_registry ||= Hooks::Registry.new
        end

        def before_actions(method_name = nil, priority: 0, &block)
          hooks_registry.register(:before_actions, method_name, priority: priority, &block)
        end

        def after_actions(method_name = nil, priority: 0, &block)
          hooks_registry.register(:after_actions, method_name, priority: priority, &block)
        end

        def around_actions(method_name = nil, priority: 0, &block)
          hooks_registry.register(:around_actions, method_name, priority: priority, &block)
        end

        def on_failure(method_name = nil, priority: 0, &block)
          hooks_registry.register(:on_failure, method_name, priority: priority, &block)
        end

        def register_extension(extension_module)
          include(extension_module)
          extension_module.register_hooks(self) if extension_module.respond_to?(:register_hooks)
        end
      end

      module InstanceMethods
        private

        def call!(**)
          hooks_runner.run_around_actions do
            super

            hooks_runner.run_before_actions
          rescue StandardError => e
            hooks_runner.run_on_failure(e)
            raise
          end

          hooks_runner.run_after_actions
        end

        def hooks_runner
          @hooks_runner ||= Hooks::Runner.new(self)
        end
      end
    end

    def self.included(base)
      base.include(Configuration::DSL)
      base.include(Info::DSL)
      base.include(Context::DSL)
      base.include(Inputs::DSL)
      base.include(Internals::DSL)
      base.include(Outputs::DSL)
      base.include(Actions::DSL)
      base.include(HooksIntegration)

      Extensions.registry.each { |extension| base.include(extension) }
    end

    def self.with_extensions(*extensions)
      Extensions.clear
      Extensions.register(*extensions)
      self
    end
  end
end
