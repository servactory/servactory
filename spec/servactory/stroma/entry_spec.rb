# frozen_string_literal: true

RSpec.describe Servactory::Stroma::Entry do
  subject(:entry) { described_class.new(key: :test, extension: test_module) }

  let(:test_module) { Module.new }

  describe ".new" do
    it { expect(entry.key).to eq(:test) }
    it { expect(entry.extension).to eq(test_module) }
  end

  describe "immutability" do
    it "is frozen" do
      expect(entry).to be_frozen
    end
  end

  describe "equality" do
    let(:same_entry) { described_class.new(key: :test, extension: test_module) }
    let(:different_key_entry) { described_class.new(key: :other, extension: test_module) }
    let(:different_module) { Module.new }
    let(:different_extension_entry) { described_class.new(key: :test, extension: different_module) }

    it "is equal to entry with same key and extension" do
      expect(entry).to eq(same_entry)
    end

    it "is not equal to entry with different key" do
      expect(entry).not_to eq(different_key_entry)
    end

    it "is not equal to entry with different extension" do
      expect(entry).not_to eq(different_extension_entry)
    end

    it "has same hash for equal entries" do
      expect(entry.hash).to eq(same_entry.hash)
    end
  end
end
