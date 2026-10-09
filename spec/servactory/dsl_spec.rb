# frozen_string_literal: true

RSpec.describe Servactory::DSL do
  describe ".with_extensions" do
    around do |example|
      registry = described_class::Extensions.registry.dup

      example.run
    ensure
      described_class::Extensions.clear
      described_class::Extensions.register(*registry)
    end

    let!(:servactory_base_class) { Servactory::Base }

    let(:trail_extension) do
      Module.new do
        const_set(
          :ClassMethods,
          Module.new do
            private

            def trail!(label)
              stroma.settings[:actions][:trail][:label] = label
            end
          end
        )

        const_set(
          :InstanceMethods,
          Module.new do
            private

            def call!(**)
              super

              outputs.trail = [*outputs.trail, self.class.stroma.settings[:actions][:trail][:label]]
            end
          end
        )

        def self.included(base)
          base.extend(self::ClassMethods)
          base.include(self::InstanceMethods)
        end
      end
    end

    let(:base_class) do
      extension = trail_extension

      Class.new do
        include Servactory::DSL.with_extensions(extension)
      end
    end

    let(:service_class) do
      Class.new(base_class) do
        trail! :after_actions

        output :trail, type: Array

        make :assign_trail

        private

        def assign_trail
          outputs.trail = [:action]
        end
      end
    end

    it "stores extensions in the process-wide registry" do
      base_class

      expect(described_class::Extensions.registry).to eq([trail_extension])
    end

    it "includes extensions into the base class" do
      expect(base_class.ancestors).to include(trail_extension, trail_extension::InstanceMethods)
    end

    it "includes extensions into every class that includes Servactory::DSL afterwards" do
      base_class

      expect(Class.new { include Servactory::DSL }.ancestors).to include(trail_extension)
    end

    it "does not include extensions into already loaded Servactory::Base" do
      base_class

      expect(Class.new(servactory_base_class).ancestors).not_to include(trail_extension)
    end

    it "makes extension class methods available in service classes", :aggregate_failures do
      expect(service_class.private_methods).to include(:trail!)
      expect(service_class.stroma.settings[:actions][:trail][:label]).to eq(:after_actions)
    end

    describe "code placed after super in the call! override" do
      it "runs after the actions with .call!", :aggregate_failures do
        result = service_class.call!

        expect(result).to be_success
        expect(result.trail).to eq(%i[action after_actions])
      end

      it "runs after the actions with .call", :aggregate_failures do
        result = service_class.call

        expect(result).to be_success
        expect(result.trail).to eq(%i[action after_actions])
      end
    end

    describe "inheritance" do
      let(:child_service_class) do
        Class.new(service_class) do
          trail! :child
        end
      end

      it "applies extensions to descendants with their own settings", :aggregate_failures do
        expect(child_service_class.call!.trail).to eq(%i[action child])
        expect(service_class.call!.trail).to eq(%i[action after_actions])
      end
    end
  end
end
