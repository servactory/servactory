# frozen_string_literal: true

RSpec.describe Servactory::Stroma::Applier do
  let(:hooks) { Servactory::Stroma::Hooks.new }
  let(:target_class) { Class.new }

  describe "#apply!" do
    context "when hooks are empty" do
      it "does nothing" do
        applier = described_class.new(target_class, hooks)
        allow(target_class).to receive(:include)
        applier.apply!
        expect(target_class).not_to have_received(:include)
      end
    end

    context "when hooks are present" do
      let(:before_module) { Module.new }
      let(:after_module) { Module.new }

      before do
        hooks.add(:before, :actions, before_module)
        hooks.add(:after, :outputs, after_module)
      end

      it "includes before hooks" do
        applier = described_class.new(target_class, hooks)
        applier.apply!
        expect(target_class.ancestors).to include(before_module)
      end

      it "includes after hooks" do
        applier = described_class.new(target_class, hooks)
        applier.apply!
        expect(target_class.ancestors).to include(after_module)
      end
    end

    context "with multiple hooks for same key" do
      let(:first_module) { Module.new }
      let(:second_module) { Module.new }

      before do
        hooks.add(:before, :actions, first_module)
        hooks.add(:before, :actions, second_module)
      end

      it "includes all hooks in order" do
        applier = described_class.new(target_class, hooks)
        applier.apply!
        expect(target_class.ancestors).to include(first_module, second_module)
      end
    end

    context "with before and after hooks for same key" do
      let(:inclusion_order) { [] }

      let(:before_module) do
        order = inclusion_order
        Module.new do
          define_singleton_method(:included) do |_base|
            order << :before
          end
        end
      end

      let(:after_module) do
        order = inclusion_order
        Module.new do
          define_singleton_method(:included) do |_base|
            order << :after
          end
        end
      end

      before do
        hooks.add(:before, :actions, before_module)
        hooks.add(:after, :actions, after_module)
      end

      it "includes before hooks before after hooks" do
        applier = described_class.new(target_class, hooks)
        applier.apply!
        expect(inclusion_order).to eq(%i[before after])
      end
    end
  end
end
