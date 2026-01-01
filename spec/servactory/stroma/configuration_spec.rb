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

  describe "#dup (via initialize_dup)" do
    let(:configuration) { described_class.new }
    let(:test_module) { Module.new }
    let(:copy) { configuration.dup }

    before do
      configuration.hooks.add(:before, :actions, test_module)
    end

    it "creates a copy with the same hooks" do
      expect(copy.hooks.before(:actions).size).to eq(1)
    end

    it "creates an independent copy", :aggregate_failures do
      copy.hooks.add(:after, :outputs, test_module)

      expect(configuration.hooks.after(:outputs)).to be_empty
      expect(copy.hooks.after(:outputs).size).to eq(1)
    end

    it "returns a new Configuration instance", :aggregate_failures do
      expect(copy).to be_a(described_class)
      expect(copy).not_to eq(configuration)
    end
  end
end
