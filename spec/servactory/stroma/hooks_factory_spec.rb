# frozen_string_literal: true

RSpec.describe Servactory::Stroma::HooksFactory do
  let(:hooks) { Servactory::Stroma::Hooks.new }
  let(:factory) { described_class.new(hooks) }
  let(:test_module1) { Module.new }
  let(:test_module2) { Module.new }

  describe "#before" do
    it "adds a before hook", :aggregate_failures do
      factory.before(:actions, test_module1)
      expect(hooks.before(:actions).size).to eq(1)
      expect(hooks.before(:actions).first.extension).to eq(test_module1)
    end

    it "adds multiple modules at once" do
      factory.before(:actions, test_module1, test_module2)
      expect(hooks.before(:actions).size).to eq(2)
    end

    it "raises UnknownHookTarget for unknown key" do
      expect { factory.before(:unknown, test_module1) }.to raise_error(
        Servactory::Stroma::Exceptions::UnknownHookTarget,
        "Unknown hook target: :unknown. " \
        "Valid keys: :configuration, :info, :context, :inputs, :internals, :outputs, :actions"
      )
    end
  end

  describe "#after" do
    it "adds an after hook", :aggregate_failures do
      factory.after(:outputs, test_module1)
      expect(hooks.after(:outputs).size).to eq(1)
      expect(hooks.after(:outputs).first.extension).to eq(test_module1)
    end

    it "adds multiple modules at once" do
      factory.after(:outputs, test_module1, test_module2)
      expect(hooks.after(:outputs).size).to eq(2)
    end

    it "raises UnknownHookTarget for unknown key" do
      expect { factory.after(:unknown, test_module1) }.to raise_error(
        Servactory::Stroma::Exceptions::UnknownHookTarget,
        "Unknown hook target: :unknown. " \
        "Valid keys: :configuration, :info, :context, :inputs, :internals, :outputs, :actions"
      )
    end
  end

  describe "valid keys" do
    it "accepts all registered keys" do
      %i[configuration info context inputs internals outputs actions].each do |key|
        expect { factory.before(key, test_module1) }.not_to raise_error
      end
    end
  end
end
