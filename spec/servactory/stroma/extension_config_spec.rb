# frozen_string_literal: true

RSpec.describe Servactory::Stroma::ExtensionConfig do
  let(:config) { described_class.new }

  describe "#[] and #[]=" do
    it "stores and retrieves values" do
      config[:method_name] = :authorize
      expect(config[:method_name]).to eq(:authorize)
    end

    it "returns nil for non-existent keys" do
      expect(config[:unknown]).to be_nil
    end

    it "stores complex values" do
      config[:options] = { enabled: true, timeout: 30 }
      expect(config[:options]).to eq({ enabled: true, timeout: 30 })
    end
  end

  describe "#key?" do
    it "returns false for non-existent key" do
      expect(config.key?(:unknown)).to be(false)
    end

    it "returns true for existing key" do
      config[:method_name] = :authorize
      expect(config.key?(:method_name)).to be(true)
    end
  end

  describe "#keys" do
    it "returns empty array for new config" do
      expect(config.keys).to eq([])
    end

    it "returns all keys" do
      config[:method_name] = :authorize
      config[:enabled] = true
      expect(config.keys).to contain_exactly(:method_name, :enabled)
    end
  end

  describe "#empty?" do
    it "returns true for new config" do
      expect(config.empty?).to be(true)
    end

    it "returns false after adding a value" do
      config[:key] = :value
      expect(config.empty?).to be(false)
    end
  end

  describe "#size" do
    it "returns 0 for new config" do
      expect(config.size).to eq(0)
    end

    it "returns count of keys" do
      config[:a] = 1
      config[:b] = 2
      expect(config.size).to eq(2)
    end
  end

  describe "#to_h" do
    it "returns empty hash for new config" do
      expect(config.to_h).to eq({})
    end

    it "returns hash with all values" do
      config[:method_name] = :authorize
      config[:enabled] = true
      expect(config.to_h).to eq({ method_name: :authorize, enabled: true })
    end

    it "returns a copy, not the original" do
      config[:key] = :value
      result = config.to_h
      result[:new_key] = :new_value
      expect(config.key?(:new_key)).to be(false)
    end
  end

  describe "#fetch" do
    before do
      config[:existing] = :value
    end

    it "returns value for existing key" do
      expect(config.fetch(:existing)).to eq(:value)
    end

    it "returns default for non-existent key" do
      expect(config.fetch(:unknown, :default)).to eq(:default)
    end

    it "yields block for non-existent key" do
      result = config.fetch(:unknown) { :from_block }
      expect(result).to eq(:from_block)
    end

    it "raises KeyError when key not found and no default" do
      expect { config.fetch(:unknown) }.to raise_error(KeyError)
    end
  end

  describe "#each" do
    it "yields each key-value pair" do
      config[:a] = 1
      config[:b] = 2
      pairs = config.map { |k, v| [k, v] }
      expect(pairs).to contain_exactly([:a, 1], [:b, 2])
    end
  end

  describe "#dup (via initialize_dup)" do
    let(:copy) { config.dup }

    before do
      config[:method_name] = :authorize
      config[:options] = { enabled: true }
    end

    it "creates a copy with the same values", :aggregate_failures do
      expect(copy[:method_name]).to eq(:authorize)
      expect(copy[:options]).to eq({ enabled: true })
    end

    it "creates an independent copy", :aggregate_failures do
      copy[:new_key] = :new_value
      expect(config.key?(:new_key)).to be(false)
    end

    it "deep copies nested hashes" do
      copy[:options][:enabled] = false
      expect(config[:options][:enabled]).to be(true)
    end

    it "deep copies nested arrays" do
      config[:list] = [1, [2, 3]]
      copy = config.dup
      copy[:list][1][0] = 99
      expect(config[:list][1][0]).to eq(2)
    end
  end
end
