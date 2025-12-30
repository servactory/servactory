# frozen_string_literal: true

RSpec.describe Servactory::DSL do
  describe ".with_extensions" do
    after { described_class::Extensions.clear }

    describe "extension inclusion order" do
      let(:execution_order) { [] }

      let(:test_extension) do
        execution_order_ref = execution_order

        Module.new do
          define_singleton_method(:included) do |base|
            base.include(Module.new do
              define_method(:call!) do |**args|
                execution_order_ref << :before_super
                super(**args)
                execution_order_ref << :after_super
              end
            end)
          end
        end
      end

      let(:service_class) do
        execution_order_ref = execution_order
        ext = test_extension

        Class.new do
          include Servactory::DSL.with_extensions(ext)

          configuration do
            failure_class StandardError
          end

          input :value, type: Integer

          output :result, type: Integer

          make :process_value

          private

          define_method(:process_value) do
            execution_order_ref << :action_executed
            outputs.result = inputs.value * 2
          end
        end
      end

      it "executes extension before and after actions" do
        service_class.call!(value: 5)

        expect(execution_order).to eq(%i[before_super action_executed after_super])
      end

      it "provides access to outputs after super" do
        outputs_after_super = nil
        execution_order_ref = execution_order

        extension_with_output_check = Module.new do
          define_singleton_method(:included) do |base|
            base.include(Module.new do
              define_method(:call!) do |**args|
                super(**args)
                outputs_after_super = outputs.result
              end
            end)
          end
        end

        service_with_output_check = Class.new do
          include Servactory::DSL.with_extensions(extension_with_output_check)

          configuration do
            failure_class StandardError
          end

          input :value, type: Integer
          output :result, type: Integer

          make :process_value

          private

          define_method(:process_value) do
            outputs.result = inputs.value * 3
          end
        end

        service_with_output_check.call!(value: 10)

        expect(outputs_after_super).to eq(30)
      end
    end

    describe "ClassMethods access to make" do
      let(:extension_with_make_access) do
        Module.new do
          def self.included(base)
            base.extend(Module.new do
              private

              def api_action(name)
                make :"perform_#{name}_request"
                make :"handle_#{name}_response"
              end
            end)
          end
        end
      end

      it "allows extensions to call make method" do
        ext = extension_with_make_access

        service_class = Class.new do
          include Servactory::DSL.with_extensions(ext)

          configuration do
            failure_class StandardError
          end

          input :id, type: Integer
          internal :response, type: Hash
          output :data, type: Hash

          api_action :fetch

          private

          def perform_fetch_request
            internals.response = { success: true, id: inputs.id }
          end

          def handle_fetch_response
            outputs.data = internals.response
          end
        end

        result = service_class.call!(id: 42)

        expect(result.data).to eq({ success: true, id: 42 })
      end
    end

    describe "MRO (Method Resolution Order)" do
      it "includes extensions after Actions::DSL" do
        test_extension = Module.new do
          def self.included(base)
            base.include(Module.new do
              def call!(**)
                super
              end
            end)
          end
        end

        service_class = Class.new do
          include Servactory::DSL.with_extensions(test_extension)

          configuration do
            failure_class StandardError
          end
        end

        ancestors = service_class.ancestors.map(&:to_s)

        # Extension module should come before Actions::Workspace in MRO
        extension_index = ancestors.index { |a| a.include?("#<Module:") }
        actions_index = ancestors.index("Servactory::Actions::Workspace")

        expect(extension_index).to be < actions_index
      end
    end

    describe "before super can stop execution" do
      it "does not execute actions when extension fails before super" do
        action_executed = false
        action_executed_ref = -> { action_executed = true }

        stopping_extension = Module.new do
          define_singleton_method(:included) do |base|
            base.include(Module.new do
              define_method(:call!) do |**args|
                raise StandardError, "Stopped before actions"
              end
            end)
          end
        end

        service_class = Class.new do
          include Servactory::DSL.with_extensions(stopping_extension)

          configuration do
            failure_class StandardError
          end

          input :value, type: Integer
          output :result, type: Integer

          make :process_value

          private

          define_method(:process_value) do
            action_executed_ref.call
            outputs.result = inputs.value
          end
        end

        expect { service_class.call!(value: 1) }.to raise_error(StandardError, "Stopped before actions")
        expect(action_executed).to be false
      end
    end
  end

  describe "Hooks" do
    after { described_class::Extensions.clear }

    describe "Hooks::Registry" do
      let(:registry) { described_class::Hooks::Registry.new }

      describe "#register" do
        it "registers a hook with symbol handler" do
          registry.register(:before_actions, :my_method, priority: 10)

          hooks = registry.hooks_for(:before_actions)
          expect(hooks.size).to eq(1)
          expect(hooks.first.handler).to eq(:my_method)
          expect(hooks.first.priority).to eq(10)
        end

        it "registers a hook with block handler" do
          registry.register(:after_actions, priority: 5) { "block result" }

          hooks = registry.hooks_for(:after_actions)
          expect(hooks.size).to eq(1)
          expect(hooks.first.handler).to be_a(Proc)
          expect(hooks.first.priority).to eq(5)
        end

        it "raises error for invalid hook point" do
          expect { registry.register(:invalid_hook, :method) }.to raise_error(ArgumentError, /Invalid hook/)
        end
      end

      describe "#hooks_for" do
        it "returns hooks sorted by priority" do
          registry.register(:before_actions, :method_c, priority: 30)
          registry.register(:before_actions, :method_a, priority: 10)
          registry.register(:before_actions, :method_b, priority: 20)

          hooks = registry.hooks_for(:before_actions)
          expect(hooks.map(&:handler)).to eq(%i[method_a method_b method_c])
        end

        it "returns empty array for hook point with no hooks" do
          expect(registry.hooks_for(:on_failure)).to eq([])
        end
      end

      describe "#dup_for_inheritance" do
        it "creates independent copy of hooks" do
          registry.register(:before_actions, :parent_method)
          child_registry = registry.dup_for_inheritance

          child_registry.register(:before_actions, :child_method)

          expect(registry.hooks_for(:before_actions).size).to eq(1)
          expect(child_registry.hooks_for(:before_actions).size).to eq(2)
        end
      end
    end

    describe "Hooks::HookEntry" do
      describe "#call" do
        let(:context) do
          Class.new do
            attr_accessor :called_with

            def my_hook_method(**options)
              self.called_with = options
              "method result"
            end
          end.new
        end

        it "calls symbol handler as method on context" do
          entry = described_class::Hooks::HookEntry.new(handler: :my_hook_method, priority: 0)

          result = entry.call(context, foo: "bar")

          expect(context.called_with).to eq({ foo: "bar" })
        end

        it "executes block handler in context" do
          block_result = nil
          entry = described_class::Hooks::HookEntry.new(
            handler: ->(foo:) { block_result = foo },
            priority: 0
          )

          entry.call(context, foo: "bar")

          expect(block_result).to eq("bar")
        end
      end
    end

    describe "before_actions hook" do
      it "has access to inputs" do
        captured_value = nil

        service_class = Class.new do
          include Servactory::DSL

          configuration do
            failure_class StandardError
          end

          input :value, type: Integer
          output :result, type: Integer

          before_actions do
            captured_value = inputs.value
          end

          make :process_value

          private

          def process_value
            outputs.result = inputs.value * 2
          end
        end

        service_class.call!(value: 42)

        expect(captured_value).to eq(42)
      end

      it "executes hooks in priority order" do
        execution_order = []

        service_class = Class.new do
          include Servactory::DSL

          configuration do
            failure_class StandardError
          end

          input :value, type: Integer
          output :result, type: Integer

          before_actions(priority: 20) { execution_order << :second }
          before_actions(priority: 10) { execution_order << :first }
          before_actions(priority: 30) { execution_order << :third }

          make :process_value

          private

          def process_value
            outputs.result = inputs.value
          end
        end

        service_class.call!(value: 1)

        expect(execution_order).to eq(%i[first second third])
      end
    end

    describe "after_actions hook" do
      it "has access to outputs" do
        captured_result = nil

        service_class = Class.new do
          include Servactory::DSL

          configuration do
            failure_class StandardError
          end

          input :value, type: Integer
          output :result, type: Integer

          after_actions do
            captured_result = outputs.result
          end

          make :process_value

          private

          def process_value
            outputs.result = inputs.value * 3
          end
        end

        service_class.call!(value: 10)

        expect(captured_result).to eq(30)
      end
    end

    describe "around_actions hook" do
      it "wraps action execution" do
        execution_order = []

        service_class = Class.new do
          include Servactory::DSL

          configuration do
            failure_class StandardError
          end

          input :value, type: Integer
          output :result, type: Integer

          around_actions do |proceed:|
            execution_order << :before_proceed
            proceed.call
            execution_order << :after_proceed
          end

          make :process_value

          private

          define_method(:process_value) do
            execution_order << :action
            outputs.result = inputs.value
          end
        end

        service_class.call!(value: 1)

        expect(execution_order).to eq(%i[before_proceed action after_proceed])
      end
    end

    describe "on_failure hook" do
      it "is called when exception occurs" do
        captured_exception = nil

        service_class = Class.new do
          include Servactory::DSL

          configuration do
            failure_class StandardError
          end

          input :value, type: Integer
          output :result, type: Integer

          on_failure do |exception:|
            captured_exception = exception
          end

          make :process_value

          private

          def process_value
            raise StandardError, "Test error"
          end
        end

        expect { service_class.call!(value: 1) }.to raise_error(StandardError, "Test error")
        expect(captured_exception).to be_a(StandardError)
        expect(captured_exception.message).to eq("Test error")
      end
    end

    describe ".register_extension" do
      it "includes extension module" do
        extension = Module.new do
          def self.included(base)
            base.extend(ClassMethods)
          end

          module ClassMethods
            def custom_macro
              @custom_macro_called = true
            end

            def custom_macro_called?
              @custom_macro_called
            end
          end
        end

        service_class = Class.new do
          include Servactory::DSL

          configuration do
            failure_class StandardError
          end

          register_extension extension
          custom_macro
        end

        expect(service_class.custom_macro_called?).to be true
      end

      it "calls register_hooks if extension responds to it" do
        hooks_registered = false

        extension = Module.new do
          define_singleton_method(:register_hooks) do |service_class|
            hooks_registered = true
            service_class.before_actions { "hook from extension" }
          end
        end

        Class.new do
          include Servactory::DSL

          configuration do
            failure_class StandardError
          end

          register_extension extension
        end

        expect(hooks_registered).to be true
      end
    end

    describe "hooks inheritance" do
      it "inherits hooks from parent class" do
        parent_hook_called = false
        child_hook_called = false

        parent_class = Class.new do
          include Servactory::DSL

          configuration do
            failure_class StandardError
          end

          before_actions { parent_hook_called = true }

          input :value, type: Integer
          output :result, type: Integer

          make :process_value

          private

          def process_value
            outputs.result = inputs.value
          end
        end

        child_class = Class.new(parent_class) do
          before_actions { child_hook_called = true }
        end

        child_class.call!(value: 1)

        expect(parent_hook_called).to be true
        expect(child_hook_called).to be true
      end

      it "does not affect parent when child adds hooks" do
        parent_class = Class.new do
          include Servactory::DSL

          configuration do
            failure_class StandardError
          end

          input :value, type: Integer
          output :result, type: Integer

          make :process_value

          private

          def process_value
            outputs.result = inputs.value
          end
        end

        child_class = Class.new(parent_class) do
          before_actions { "child hook" }
        end

        expect(parent_class.hooks_registry.hooks_for(:before_actions).size).to eq(0)
        expect(child_class.hooks_registry.hooks_for(:before_actions).size).to eq(1)
      end
    end
  end
end
