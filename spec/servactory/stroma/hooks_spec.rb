# frozen_string_literal: true

RSpec.describe Servactory::Stroma::Hooks do
  let(:hooks) { described_class.new }
  let(:first_module) { Module.new }
  let(:second_module) { Module.new }

  describe "#add" do
    it "adds a hook to the collection" do
      hooks.add(:before, :actions, first_module)
      expect(hooks.before(:actions).size).to eq(1)
    end

    it "allows multiple hooks for the same key" do
      hooks.add(:before, :actions, first_module)
      hooks.add(:before, :actions, second_module)
      expect(hooks.before(:actions).size).to eq(2)
    end
  end

  describe "#before" do
    before do
      hooks.add(:before, :actions, first_module)
      hooks.add(:after, :actions, second_module)
      hooks.add(:before, :outputs, second_module)
    end

    it "returns only before hooks for the specified key", :aggregate_failures do
      result = hooks.before(:actions)
      expect(result.size).to eq(1)
      expect(result.first.extension).to eq(first_module)
    end

    it "returns empty array for key without before hooks" do
      expect(hooks.before(:inputs)).to eq([])
    end
  end

  describe "#after" do
    before do
      hooks.add(:before, :actions, first_module)
      hooks.add(:after, :actions, second_module)
    end

    it "returns only after hooks for the specified key", :aggregate_failures do
      result = hooks.after(:actions)
      expect(result.size).to eq(1)
      expect(result.first.extension).to eq(second_module)
    end

    it "returns empty array for key without after hooks" do
      expect(hooks.after(:inputs)).to eq([])
    end
  end

  describe "#empty?" do
    it "returns true for new hooks collection" do
      expect(hooks.empty?).to be(true)
    end

    it "returns false after adding a hook" do
      hooks.add(:before, :actions, first_module)
      expect(hooks.empty?).to be(false)
    end
  end

  describe "#dup (via initialize_dup)" do
    before do
      hooks.add(:before, :actions, first_module)
      hooks.add(:after, :outputs, second_module)
    end

    it "creates a copy with the same hooks", :aggregate_failures do
      copy = hooks.dup
      expect(copy.before(:actions).size).to eq(1)
      expect(copy.after(:outputs).size).to eq(1)
    end

    it "creates an independent copy", :aggregate_failures do
      copy = hooks.dup
      copy.add(:before, :inputs, second_module)
      expect(hooks.before(:inputs)).to be_empty
      expect(copy.before(:inputs).size).to eq(1)
    end
  end
end
