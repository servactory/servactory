# frozen_string_literal: true

RSpec.describe Servactory::Stroma::Hook do
  let(:test_module) { Module.new }

  describe ".new" do
    subject(:hook) { described_class.new(type: :before, target_key: :actions, extension: test_module) }

    it { expect(hook.type).to eq(:before) }
    it { expect(hook.target_key).to eq(:actions) }
    it { expect(hook.extension).to eq(test_module) }
  end

  describe "#before?" do
    it "returns true for before type" do
      hook = described_class.new(type: :before, target_key: :actions, extension: test_module)
      expect(hook.before?).to be(true)
    end

    it "returns false for after type" do
      hook = described_class.new(type: :after, target_key: :actions, extension: test_module)
      expect(hook.before?).to be(false)
    end
  end

  describe "#after?" do
    it "returns true for after type" do
      hook = described_class.new(type: :after, target_key: :outputs, extension: test_module)
      expect(hook.after?).to be(true)
    end

    it "returns false for before type" do
      hook = described_class.new(type: :before, target_key: :outputs, extension: test_module)
      expect(hook.after?).to be(false)
    end
  end

  describe "immutability" do
    it "is immutable (Data object)" do
      hook = described_class.new(type: :before, target_key: :actions, extension: test_module)
      expect { hook.instance_variable_set(:@type, :after) }.to raise_error(FrozenError)
    end
  end

  describe "type validation" do
    it "accepts :before type" do
      expect { described_class.new(type: :before, target_key: :actions, extension: test_module) }
        .not_to raise_error
    end

    it "accepts :after type" do
      expect { described_class.new(type: :after, target_key: :actions, extension: test_module) }
        .not_to raise_error
    end

    it "raises InvalidHookType for invalid type" do
      expect { described_class.new(type: :invalid, target_key: :actions, extension: test_module) }
        .to raise_error(
          Servactory::Stroma::Exceptions::InvalidHookType,
          "Invalid hook type: :invalid. Valid types: :before, :after"
        )
    end

    it "raises InvalidHookType for nil type" do
      expect { described_class.new(type: nil, target_key: :actions, extension: test_module) }
        .to raise_error(Servactory::Stroma::Exceptions::InvalidHookType)
    end
  end
end
