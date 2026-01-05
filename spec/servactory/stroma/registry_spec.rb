# frozen_string_literal: true

RSpec.describe Servactory::Stroma::Registry do
  # NOTE: Registry is a Singleton and is already populated by Servactory::DSL.
  #       We test using the already-finalized registry.

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

  describe ".register" do
    it "raises RegistryFrozen when registry is finalized" do
      expect { described_class.register(:test, Module.new) }.to raise_error(
        Servactory::Stroma::Exceptions::RegistryFrozen,
        "Registry is finalized"
      )
    end
  end

  describe ".key?" do
    it "returns true for registered key" do
      expect(described_class.key?(:inputs)).to be(true)
    end

    it "returns true for all registered keys" do
      %i[configuration info context inputs internals outputs actions].each do |key|
        expect(described_class.key?(key)).to be(true)
      end
    end

    it "returns false for unregistered key" do
      expect(described_class.key?(:unknown)).to be(false)
    end

    it "returns false for nil" do
      expect(described_class.key?(nil)).to be(false)
    end
  end

  describe ".finalize!" do
    it "is idempotent - can be called multiple times" do
      expect { described_class.finalize! }.not_to raise_error
    end
  end
end
