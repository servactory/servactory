# frozen_string_literal: true

RSpec.describe Servactory::Stroma::State do
  describe "#initialize" do
    subject(:state) { described_class.new }

    it "creates a new hooks collection" do
      expect(state.hooks).to be_a(Servactory::Stroma::Hooks::Collection)
    end

    it "creates a new settings collection" do
      expect(state.settings).to be_a(Servactory::Stroma::Settings::Collection)
    end

    it "starts with empty hooks" do
      expect(state.hooks.empty?).to be(true)
    end

    it "starts with empty settings" do
      expect(state.settings.empty?).to be(true)
    end
  end

  describe "#dup (via initialize_dup)" do
    let(:state) { described_class.new }
    let(:test_module) { Module.new }
    let(:copy) { state.dup }

    before do
      state.hooks.add(:before, :actions, test_module)
      state.settings[:actions][:authorization][:method_name] = :authorize
    end

    it "creates a copy with the same hooks" do
      expect(copy.hooks.before(:actions).size).to eq(1)
    end

    it "creates a copy with the same settings" do
      expect(copy.settings[:actions][:authorization][:method_name]).to eq(:authorize)
    end

    it "creates an independent copy for hooks", :aggregate_failures do
      copy.hooks.add(:after, :outputs, test_module)

      expect(state.hooks.after(:outputs)).to be_empty
      expect(copy.hooks.after(:outputs).size).to eq(1)
    end

    it "creates an independent copy for settings", :aggregate_failures do
      copy.settings[:actions][:authorization][:new_key] = :new_value

      expect(state.settings[:actions][:authorization].key?(:new_key)).to be(false)
      expect(copy.settings[:actions][:authorization][:new_key]).to eq(:new_value)
    end

    it "returns a new State instance", :aggregate_failures do
      expect(copy).to be_a(described_class)
      expect(copy).not_to eq(state)
    end
  end
end
