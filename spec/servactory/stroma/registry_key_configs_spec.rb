# frozen_string_literal: true

RSpec.describe Servactory::Stroma::RegistryKeyConfigs do
  let(:configs) { described_class.new }

  describe "#[]" do
    it "auto-vivifies ExtensionConfig on first access" do
      result = configs[:authorization]
      expect(result).to be_a(Servactory::Stroma::ExtensionConfig)
    end

    it "returns the same ExtensionConfig on subsequent access" do
      first = configs[:authorization]
      second = configs[:authorization]
      expect(first).to be(second)
    end

    it "converts string keys to symbols" do
      configs["authorization"][:key] = :value
      expect(configs[:authorization][:key]).to eq(:value)
    end
  end

  describe "#keys" do
    it "returns empty array for new collection" do
      expect(configs.keys).to eq([])
    end

    it "returns all extension names" do
      configs[:authorization][:method_name] = :authorize
      configs[:transactional][:enabled] = true
      expect(configs.keys).to contain_exactly(:authorization, :transactional)
    end
  end

  describe "#empty?" do
    it "returns true for new collection" do
      expect(configs.empty?).to be(true)
    end

    it "returns false after accessing an extension" do
      configs[:authorization]
      expect(configs.empty?).to be(false)
    end
  end

  describe "#size" do
    it "returns 0 for new collection" do
      expect(configs.size).to eq(0)
    end

    it "returns count of extensions" do
      configs[:authorization][:key] = :value
      configs[:transactional][:key] = :value
      expect(configs.size).to eq(2)
    end
  end

  describe "#to_h" do
    it "returns empty hash for new collection" do
      expect(configs.to_h).to eq({})
    end

    it "returns nested hash with all values" do
      configs[:authorization][:method_name] = :authorize
      configs[:transactional][:enabled] = true

      expected = {
        authorization: { method_name: :authorize },
        transactional: { enabled: true }
      }
      expect(configs.to_h).to eq(expected)
    end
  end

  describe "#each" do
    it "yields each extension name and config" do
      configs[:authorization][:key] = :value
      configs[:transactional][:key] = :value

      pairs = configs.map { |name, config| [name, config.class] }
      expect(pairs).to contain_exactly(
        [:authorization, Servactory::Stroma::ExtensionConfig],
        [:transactional, Servactory::Stroma::ExtensionConfig]
      )
    end
  end

  describe "#dup (via initialize_dup)" do
    let(:copy) { configs.dup }

    before do
      configs[:authorization][:method_name] = :authorize
      configs[:transactional][:enabled] = true
    end

    it "creates a copy with the same values", :aggregate_failures do
      expect(copy[:authorization][:method_name]).to eq(:authorize)
      expect(copy[:transactional][:enabled]).to be(true)
    end

    it "creates an independent copy - new extensions" do
      copy[:new_extension][:key] = :value
      expect(configs.keys).to contain_exactly(:authorization, :transactional)
    end

    it "creates an independent copy - extension values" do
      copy[:authorization][:new_key] = :new_value
      expect(configs[:authorization].key?(:new_key)).to be(false)
    end
  end
end
