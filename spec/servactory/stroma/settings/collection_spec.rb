# frozen_string_literal: true

RSpec.describe Servactory::Stroma::Settings::Collection do
  let(:settings) { described_class.new }

  describe "#[]" do
    it "auto-vivifies RegistrySettings on first access" do
      result = settings[:actions]
      expect(result).to be_a(Servactory::Stroma::Settings::RegistrySettings)
    end

    it "returns the same RegistrySettings on subsequent access" do
      first = settings[:actions]
      second = settings[:actions]
      expect(first).to be(second)
    end

    it "converts string keys to symbols" do
      settings["actions"][:authorization][:key] = :value
      expect(settings[:actions][:authorization][:key]).to eq(:value)
    end
  end

  describe "#keys" do
    it "returns empty array for new collection" do
      expect(settings.keys).to eq([])
    end

    it "returns all registry keys" do
      settings[:actions][:authorization][:method_name] = :authorize
      settings[:inputs][:validator][:enabled] = true
      expect(settings.keys).to contain_exactly(:actions, :inputs)
    end
  end

  describe "#empty?" do
    it "returns true for new collection" do
      expect(settings.empty?).to be(true)
    end

    it "returns false after accessing a registry key" do
      settings[:actions]
      expect(settings.empty?).to be(false)
    end
  end

  describe "#size" do
    it "returns 0 for new collection" do
      expect(settings.size).to eq(0)
    end

    it "returns count of registry keys" do
      settings[:actions][:ext1][:key] = :value # rubocop:disable Naming/VariableNumber
      settings[:inputs][:ext2][:key] = :value # rubocop:disable Naming/VariableNumber
      expect(settings.size).to eq(2)
    end
  end

  describe "#to_h" do
    it "returns empty hash for new collection" do
      expect(settings.to_h).to eq({})
    end

    it "returns deeply nested hash with all values" do
      settings[:actions][:authorization][:method_name] = :authorize
      settings[:actions][:transactional][:enabled] = true
      settings[:inputs][:validator][:strict] = false

      expected = {
        actions: {
          authorization: { method_name: :authorize },
          transactional: { enabled: true }
        },
        inputs: {
          validator: { strict: false }
        }
      }
      expect(settings.to_h).to eq(expected)
    end
  end

  describe "#each" do
    it "yields each registry key and settings" do
      settings[:actions][:ext][:key] = :value
      settings[:inputs][:ext][:key] = :value

      pairs = settings.map { |key, registry_settings| [key, registry_settings.class] }
      expect(pairs).to contain_exactly(
        [:actions, Servactory::Stroma::Settings::RegistrySettings],
        [:inputs, Servactory::Stroma::Settings::RegistrySettings]
      )
    end
  end

  describe "#dup (via initialize_dup)" do
    let(:copy) { settings.dup }

    before do
      settings[:actions][:authorization][:method_name] = :authorize
      settings[:actions][:transactional][:enabled] = true
      settings[:inputs][:validator][:strict] = false
    end

    it "creates a copy with the same values", :aggregate_failures do
      expect(copy[:actions][:authorization][:method_name]).to eq(:authorize)
      expect(copy[:actions][:transactional][:enabled]).to be(true)
      expect(copy[:inputs][:validator][:strict]).to be(false)
    end

    it "creates an independent copy - new registry keys" do
      copy[:outputs][:formatter][:key] = :value
      expect(settings.keys).to contain_exactly(:actions, :inputs)
    end

    it "creates an independent copy - new extensions" do
      copy[:actions][:new_extension][:key] = :value
      expect(settings[:actions].keys).to contain_exactly(:authorization, :transactional)
    end

    it "creates an independent copy - extension values" do
      copy[:actions][:authorization][:new_key] = :new_value
      expect(settings[:actions][:authorization].key?(:new_key)).to be(false)
    end
  end

  describe "hierarchical access pattern" do
    it "supports the expected usage pattern", :aggregate_failures do
      # Set settings
      settings[:actions][:authorization][:method_name] = :check_permission
      settings[:actions][:authorization][:required] = true
      settings[:actions][:transactional][:enabled] = true
      settings[:actions][:transactional][:class] = "ActiveRecord::Base"

      # Read settings
      expect(settings[:actions][:authorization][:method_name]).to eq(:check_permission)
      expect(settings[:actions][:authorization][:required]).to be(true)
      expect(settings[:actions][:transactional][:enabled]).to be(true)
      expect(settings[:actions][:transactional][:class]).to eq("ActiveRecord::Base")
    end
  end
end
