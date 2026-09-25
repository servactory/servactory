# frozen_string_literal: true

RSpec.describe Servactory::Configuration::OptionHelpers::OptionHelpersCollection do
  subject(:collection) { described_class.new([optional_helper, inclusion_helper]) }

  let(:optional_helper) do
    Servactory::Maintenance::Options::Helper.new(name: :optional, equivalent: { required: false })
  end

  let(:inclusion_helper) { Servactory::ToolKit::DynamicOptions::Inclusion.use }

  let(:positive_helper) do
    Servactory::Maintenance::Options::Helper.new(
      name: :positive,
      equivalent: {
        must: {
          be_positive: {
            is: ->(value:, **) { value.positive? },
            message: "Must be positive"
          }
        }
      }
    )
  end

  describe "#each" do
    it "yields helpers in registration order" do
      expect(collection.to_a).to eq([optional_helper, inclusion_helper])
    end

    it "returns an enumerator without a block" do
      expect(collection.each.to_a).to eq([optional_helper, inclusion_helper])
    end
  end

  describe "#find" do
    it "is available through Enumerable" do
      expect(collection.find { |helper| helper.name == :inclusion }).to be(inclusion_helper)
    end
  end

  describe "#find_by" do
    it "returns the helper registered under the name" do
      expect(collection.find_by(name: :optional)).to be(optional_helper)
    end

    it "returns nil for an unknown name" do
      expect(collection.find_by(name: :positive)).to be_nil
    end

    it "finds a helper registered after a previous lookup" do
      collection.find_by(name: :optional)
      collection << positive_helper

      expect(collection.find_by(name: :positive)).to be(positive_helper)
    end
  end

  describe "#<<" do
    it "appends a helper with a new name" do
      collection << positive_helper

      expect(collection.map(&:name)).to eq(%i[optional inclusion positive])
    end

    it "replaces a helper with the same name in place" do
      new_optional_helper = Servactory::Maintenance::Options::Helper.new(name: :optional, equivalent: {})
      collection << new_optional_helper

      expect(collection.to_a).to eq([new_optional_helper, inclusion_helper])
    end
  end

  describe "#merge" do
    it "registers helpers in order" do
      collection.merge([positive_helper])

      expect(collection.map(&:name)).to eq(%i[optional inclusion positive])
    end
  end

  describe "#dynamic_options" do
    it "returns a collection of dynamic option helpers only", :aggregate_failures do
      dynamic_options = collection.dynamic_options

      expect(dynamic_options).to be_a(described_class)
      expect(dynamic_options.to_a).to eq([inclusion_helper])
    end
  end

  describe "#replace" do
    let(:new_inclusion_helper) { Servactory::ToolKit::DynamicOptions::Inclusion.use }

    it "replaces the helper keeping its position", :aggregate_failures do
      collection.replace(name: :inclusion, with: new_inclusion_helper)

      expect(collection.to_a).to eq([optional_helper, new_inclusion_helper])
      expect(collection.find_by(name: :inclusion)).to be(new_inclusion_helper)
    end

    it "ignores an unknown name" do
      collection.replace(name: :positive, with: positive_helper)

      expect(collection.find_by(name: :positive)).to be_nil
    end
  end

  describe "#dup" do
    it "does not share registrations with the original", :aggregate_failures do
      copy = collection.dup
      copy << positive_helper

      expect(copy.find_by(name: :positive)).to be(positive_helper)
      expect(collection.find_by(name: :positive)).to be_nil
    end
  end
end
