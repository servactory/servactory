# frozen_string_literal: true

RSpec.describe Servactory::Stroma::Settings::Setting do
  let(:setting) { described_class.new }

  describe "#[] and #[]=" do
    it "stores and retrieves values" do
      setting[:method_name] = :authorize
      expect(setting[:method_name]).to eq(:authorize)
    end

    it "returns nil for non-existent keys" do
      expect(setting[:unknown]).to be_nil
    end

    it "stores complex values" do
      setting[:options] = { enabled: true, timeout: 30 }
      expect(setting[:options]).to eq({ enabled: true, timeout: 30 })
    end
  end

  describe "#key?" do
    it "returns false for non-existent key" do
      expect(setting.key?(:unknown)).to be(false)
    end

    it "returns true for existing key" do
      setting[:method_name] = :authorize
      expect(setting.key?(:method_name)).to be(true)
    end
  end

  describe "#keys" do
    it "returns empty array for new setting" do
      expect(setting.keys).to eq([])
    end

    it "returns all keys" do
      setting[:method_name] = :authorize
      setting[:enabled] = true
      expect(setting.keys).to contain_exactly(:method_name, :enabled)
    end
  end

  describe "#empty?" do
    it "returns true for new setting" do
      expect(setting.empty?).to be(true)
    end

    it "returns false after adding a value" do
      setting[:key] = :value
      expect(setting.empty?).to be(false)
    end
  end

  describe "#size" do
    it "returns 0 for new setting" do
      expect(setting.size).to eq(0)
    end

    it "returns count of keys" do
      setting[:a] = 1
      setting[:b] = 2
      expect(setting.size).to eq(2)
    end
  end

  describe "#to_h" do
    it "returns empty hash for new setting" do
      expect(setting.to_h).to eq({})
    end

    it "returns hash with all values" do
      setting[:method_name] = :authorize
      setting[:enabled] = true
      expect(setting.to_h).to eq({ method_name: :authorize, enabled: true })
    end

    it "returns a copy, not the original" do
      setting[:key] = :value
      result = setting.to_h
      result[:new_key] = :new_value
      expect(setting.key?(:new_key)).to be(false)
    end
  end

  describe "#fetch" do
    before do
      setting[:existing] = :value
    end

    it "returns value for existing key" do
      expect(setting.fetch(:existing)).to eq(:value)
    end

    it "returns default for non-existent key" do
      expect(setting.fetch(:unknown, :default)).to eq(:default)
    end

    it "yields block for non-existent key" do
      result = setting.fetch(:unknown) { :from_block }
      expect(result).to eq(:from_block)
    end

    it "raises KeyError when key not found and no default" do
      expect { setting.fetch(:unknown) }.to raise_error(KeyError)
    end
  end

  describe "#each" do
    it "yields each key-value pair" do
      setting[:a] = 1
      setting[:b] = 2
      pairs = setting.map { |k, v| [k, v] }
      expect(pairs).to contain_exactly([:a, 1], [:b, 2])
    end
  end

  describe "#dup (via initialize_dup)" do
    let(:copy) { setting.dup }

    before do
      setting[:method_name] = :authorize
      setting[:options] = { enabled: true }
    end

    it "creates a copy with the same values", :aggregate_failures do
      expect(copy[:method_name]).to eq(:authorize)
      expect(copy[:options]).to eq({ enabled: true })
    end

    it "creates an independent copy", :aggregate_failures do
      copy[:new_key] = :new_value
      expect(setting.key?(:new_key)).to be(false)
    end

    it "deep copies nested hashes" do
      copy[:options][:enabled] = false
      expect(setting[:options][:enabled]).to be(true)
    end

    it "deep copies nested arrays" do
      setting[:list] = [1, [2, 3]]
      copy = setting.dup
      copy[:list][1][0] = 99
      expect(setting[:list][1][0]).to eq(2)
    end
  end
end
