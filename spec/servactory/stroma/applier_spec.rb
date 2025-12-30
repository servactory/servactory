# frozen_string_literal: true

RSpec.describe Servactory::Stroma::Applier do
  let(:hooks) { Servactory::Stroma::Hooks.new }
  let(:target_class) { Class.new }

  describe "#apply!" do
    context "when hooks are empty" do
      it "does nothing" do
        applier = described_class.new(target_class, hooks)
        expect(target_class).not_to receive(:include)
        applier.apply!
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
      let(:module1) { Module.new }
      let(:module2) { Module.new }

      before do
        hooks.add(:before, :actions, module1)
        hooks.add(:before, :actions, module2)
      end

      it "includes all hooks in order" do
        applier = described_class.new(target_class, hooks)
        applier.apply!
        expect(target_class.ancestors).to include(module1, module2)
      end
    end
  end
end
