# frozen_string_literal: true

RSpec.describe Servactory::Stroma::Settings::RegistrySettings do
  let(:settings) { described_class.new }

  describe "#[]" do
    it "auto-vivifies Setting on first access" do
      result = settings[:authorization]
      expect(result).to be_a(Servactory::Stroma::Settings::Setting)
    end

    it "returns the same Setting on subsequent access" do
      first = settings[:authorization]
      second = settings[:authorization]
      expect(first).to be(second)
    end

    it "converts string keys to symbols" do
      settings["authorization"][:key] = :value
      expect(settings[:authorization][:key]).to eq(:value)
    end
  end

  describe "#keys" do
    it "returns empty array for new collection" do
      expect(settings.keys).to eq([])
    end

    it "returns all extension names" do
      settings[:authorization][:method_name] = :authorize
      settings[:transactional][:enabled] = true
      expect(settings.keys).to contain_exactly(:authorization, :transactional)
    end
  end

  describe "#empty?" do
    it "returns true for new collection" do
      expect(settings.empty?).to be(true)
    end

    it "returns false after accessing an extension" do
      settings[:authorization]
      expect(settings.empty?).to be(false)
    end
  end

  describe "#size" do
    it "returns 0 for new collection" do
      expect(settings.size).to eq(0)
    end

    it "returns count of extensions" do
      settings[:authorization][:key] = :value
      settings[:transactional][:key] = :value
      expect(settings.size).to eq(2)
    end
  end

  describe "#to_h" do
    it "returns empty hash for new collection" do
      expect(settings.to_h).to eq({})
    end

    it "returns nested hash with all values" do
      settings[:authorization][:method_name] = :authorize
      settings[:transactional][:enabled] = true

      expected = {
        authorization: { method_name: :authorize },
        transactional: { enabled: true }
      }
      expect(settings.to_h).to eq(expected)
    end
  end

  describe "#each" do
    it "yields each extension name and setting" do
      settings[:authorization][:key] = :value
      settings[:transactional][:key] = :value

      pairs = settings.map { |name, setting| [name, setting.class] }
      expect(pairs).to contain_exactly(
        [:authorization, Servactory::Stroma::Settings::Setting],
        [:transactional, Servactory::Stroma::Settings::Setting]
      )
    end
  end

  describe "#dup (via initialize_dup)" do
    let(:copy) { settings.dup }

    before do
      settings[:authorization][:method_name] = :authorize
      settings[:transactional][:enabled] = true
    end

    it "creates a copy with the same values", :aggregate_failures do
      expect(copy[:authorization][:method_name]).to eq(:authorize)
      expect(copy[:transactional][:enabled]).to be(true)
    end

    it "creates an independent copy - new extensions" do
      copy[:new_extension][:key] = :value
      expect(settings.keys).to contain_exactly(:authorization, :transactional)
    end

    it "creates an independent copy - extension values" do
      copy[:authorization][:new_key] = :new_value
      expect(settings[:authorization].key?(:new_key)).to be(false)
    end
  end
end
