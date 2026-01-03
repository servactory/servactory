# frozen_string_literal: true

RSpec.describe Servactory::Stroma::ExtensionConfigs do
  let(:configs) { described_class.new }

  describe "#[]" do
    it "auto-vivifies RegistryKeyConfigs on first access" do
      result = configs[:actions]
      expect(result).to be_a(Servactory::Stroma::RegistryKeyConfigs)
    end

    it "returns the same RegistryKeyConfigs on subsequent access" do
      first = configs[:actions]
      second = configs[:actions]
      expect(first).to be(second)
    end

    it "converts string keys to symbols" do
      configs["actions"][:authorization][:key] = :value
      expect(configs[:actions][:authorization][:key]).to eq(:value)
    end
  end

  describe "#keys" do
    it "returns empty array for new collection" do
      expect(configs.keys).to eq([])
    end

    it "returns all registry keys" do
      configs[:actions][:authorization][:method_name] = :authorize
      configs[:inputs][:validator][:enabled] = true
      expect(configs.keys).to contain_exactly(:actions, :inputs)
    end
  end

  describe "#empty?" do
    it "returns true for new collection" do
      expect(configs.empty?).to be(true)
    end

    it "returns false after accessing a registry key" do
      configs[:actions]
      expect(configs.empty?).to be(false)
    end
  end

  describe "#size" do
    it "returns 0 for new collection" do
      expect(configs.size).to eq(0)
    end

    it "returns count of registry keys" do
      configs[:actions][:ext1][:key] = :value
      configs[:inputs][:ext2][:key] = :value
      expect(configs.size).to eq(2)
    end
  end

  describe "#to_h" do
    it "returns empty hash for new collection" do
      expect(configs.to_h).to eq({})
    end

    it "returns deeply nested hash with all values" do
      configs[:actions][:authorization][:method_name] = :authorize
      configs[:actions][:transactional][:enabled] = true
      configs[:inputs][:validator][:strict] = false

      expected = {
        actions: {
          authorization: { method_name: :authorize },
          transactional: { enabled: true }
        },
        inputs: {
          validator: { strict: false }
        }
      }
      expect(configs.to_h).to eq(expected)
    end
  end

  describe "#each" do
    it "yields each registry key and configs" do
      configs[:actions][:ext][:key] = :value
      configs[:inputs][:ext][:key] = :value

      pairs = configs.map { |key, registry_configs| [key, registry_configs.class] }
      expect(pairs).to contain_exactly(
        [:actions, Servactory::Stroma::RegistryKeyConfigs],
        [:inputs, Servactory::Stroma::RegistryKeyConfigs]
      )
    end
  end

  describe "#dup (via initialize_dup)" do
    let(:copy) { configs.dup }

    before do
      configs[:actions][:authorization][:method_name] = :authorize
      configs[:actions][:transactional][:enabled] = true
      configs[:inputs][:validator][:strict] = false
    end

    it "creates a copy with the same values", :aggregate_failures do
      expect(copy[:actions][:authorization][:method_name]).to eq(:authorize)
      expect(copy[:actions][:transactional][:enabled]).to be(true)
      expect(copy[:inputs][:validator][:strict]).to be(false)
    end

    it "creates an independent copy - new registry keys" do
      copy[:outputs][:formatter][:key] = :value
      expect(configs.keys).to contain_exactly(:actions, :inputs)
    end

    it "creates an independent copy - new extensions" do
      copy[:actions][:new_extension][:key] = :value
      expect(configs[:actions].keys).to contain_exactly(:authorization, :transactional)
    end

    it "creates an independent copy - extension values" do
      copy[:actions][:authorization][:new_key] = :new_value
      expect(configs[:actions][:authorization].key?(:new_key)).to be(false)
    end
  end

  describe "hierarchical access pattern" do
    it "supports the expected usage pattern" do
      # Set configuration
      configs[:actions][:authorization][:method_name] = :check_permission
      configs[:actions][:authorization][:required] = true
      configs[:actions][:transactional][:enabled] = true
      configs[:actions][:transactional][:class] = "ActiveRecord::Base"

      # Read configuration
      expect(configs[:actions][:authorization][:method_name]).to eq(:check_permission)
      expect(configs[:actions][:authorization][:required]).to be(true)
      expect(configs[:actions][:transactional][:enabled]).to be(true)
      expect(configs[:actions][:transactional][:class]).to eq("ActiveRecord::Base")
    end
  end
end
