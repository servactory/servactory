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
end
