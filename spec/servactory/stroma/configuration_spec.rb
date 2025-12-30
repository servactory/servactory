# frozen_string_literal: true

RSpec.describe Servactory::Stroma::Configuration do
  describe "#initialize" do
    subject(:configuration) { described_class.new }

    it "creates a new hooks collection" do
      expect(configuration.hooks).to be_a(Servactory::Stroma::Hooks)
    end

    it "starts with empty hooks" do
      expect(configuration.hooks.empty?).to be(true)
    end
  end

  describe "#dup_for_inheritance" do
    let(:configuration) { described_class.new }
    let(:test_module) { Module.new }

    before do
      configuration.hooks.add(:before, :actions, test_module)
    end

    it "creates a copy with the same hooks" do
      copy = configuration.dup_for_inheritance
      expect(copy.hooks.before(:actions).size).to eq(1)
    end

    it "creates an independent copy" do
      copy = configuration.dup_for_inheritance
      copy.hooks.add(:after, :outputs, test_module)

      expect(configuration.hooks.after(:outputs)).to be_empty
      expect(copy.hooks.after(:outputs).size).to eq(1)
    end

    it "returns a new Configuration instance" do
      copy = configuration.dup_for_inheritance
      expect(copy).to be_a(described_class)
      expect(copy).not_to eq(configuration)
    end
  end
end
