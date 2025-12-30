# frozen_string_literal: true

RSpec.describe Servactory::Stroma::Registry do
  # NOTE: Registry is a Singleton and is already populated by Servactory::DSL.
  # We test using the already-finalized registry.

  describe ".finalized?" do
    it "returns true (registry is finalized by Servactory::DSL)" do
      expect(described_class.finalized?).to be(true)
    end
  end

  describe ".entries" do
    it "returns all registered entries", :aggregate_failures do
      expect(described_class.entries).to be_an(Array)
      expect(described_class.entries).not_to be_empty
    end

    it "contains DSL modules in order" do
      keys = described_class.entries.map(&:key)
      expect(keys).to eq(%i[configuration info context inputs internals outputs actions])
    end
  end

  describe ".keys" do
    it "returns all registered keys" do
      expect(described_class.keys).to eq(%i[configuration info context inputs internals outputs actions])
    end
  end

  describe ".find" do
    it "returns entry for existing key", :aggregate_failures do
      entry = described_class.find(:inputs)
      expect(entry).to be_a(Servactory::Stroma::Registry::Entry)
      expect(entry.key).to eq(:inputs)
      expect(entry.mod).to eq(Servactory::Inputs::DSL)
    end

    it "returns nil for non-existing key" do
      expect(described_class.find(:nonexistent)).to be_nil
    end
  end

  describe ".register" do
    it "raises FrozenError when registry is finalized" do
      expect { described_class.register(:test, Module.new) }.to raise_error(FrozenError, "Registry is finalized")
    end
  end

  describe "Entry" do
    describe ".new" do
      subject(:entry) { Servactory::Stroma::Registry::Entry.new(key: :test, mod: test_module) }

      let(:test_module) { Module.new }

      it { expect(entry.key).to eq(:test) }
      it { expect(entry.mod).to eq(test_module) }
    end
  end
end
