# frozen_string_literal: true

RSpec.describe Servactory::Configuration::OptionHelpers::OptionHelpersCollection do
  subject(:collection) { described_class.new([optional_helper, inclusion_helper]) }

  let(:optional_helper) do
    Servactory::Maintenance::Options::Helper.new(name: :optional, equivalent: { required: false })
  end

  let(:inclusion_helper) { Servactory::ToolKit::DynamicOptions::Inclusion.use }

  let(:positive_helper) { build_helper(:positive) }

  def build_helper(name)
    Servactory::Maintenance::Options::Helper.new(name:, equivalent: {})
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
      collection.register(positive_helper)

      expect(collection.find_by(name: :positive)).to be(positive_helper)
    end
  end

  describe "#register" do
    context "when the name is new" do
      it "returns :registered" do
        expect(collection.register(positive_helper)).to eq(:registered)
      end

      it "appends the helper" do
        collection.register(positive_helper)

        expect(collection.map(&:name)).to eq(%i[optional inclusion positive])
      end
    end

    context "when the very same helper is already registered" do
      before { collection.register(positive_helper) }

      it "returns :skipped" do
        expect(collection.register(positive_helper)).to eq(:skipped)
      end

      it "keeps the collection unchanged" do
        collection.register(positive_helper)

        expect(collection.to_a).to eq([optional_helper, inclusion_helper, positive_helper])
      end
    end

    context "when the very same built-in helper is registered" do
      it "returns :skipped" do
        expect(collection.register(optional_helper)).to eq(:skipped)
      end
    end

    context "when the name belongs to a built-in helper" do
      let(:custom_optional_helper) { build_helper(:optional) }

      it "returns :reserved" do
        expect(collection.register(custom_optional_helper)).to eq(:reserved)
      end

      it "keeps the built-in helper" do
        collection.register(custom_optional_helper)

        expect(collection.to_a).to eq([optional_helper, inclusion_helper])
      end
    end

    context "when another helper with the name is already registered" do
      let(:another_positive_helper) { build_helper(:positive) }

      before { collection.register(positive_helper) }

      it "returns :duplicated" do
        expect(collection.register(another_positive_helper)).to eq(:duplicated)
      end

      it "keeps the first helper" do
        collection.register(another_positive_helper)

        expect(collection.find_by(name: :positive)).to be(positive_helper)
      end
    end
  end

  describe "#dynamic_options" do
    it "returns a collection of dynamic option helpers only", :aggregate_failures do
      dynamic_options = collection.dynamic_options

      expect(dynamic_options).to be_a(described_class)
      expect(dynamic_options.to_a).to eq([inclusion_helper])
    end

    it "includes registered dynamic option helpers" do
      format_helper = Servactory::ToolKit::DynamicOptions::Format.use
      collection.register(format_helper)

      expect(collection.dynamic_options.to_a).to eq([inclusion_helper, format_helper])
    end
  end

  describe "#replace" do
    let(:new_inclusion_helper) { Servactory::ToolKit::DynamicOptions::Inclusion.use }

    it "replaces a built-in helper keeping its position", :aggregate_failures do
      collection.replace(name: :inclusion, with: new_inclusion_helper)

      expect(collection.to_a).to eq([optional_helper, new_inclusion_helper])
      expect(collection.find_by(name: :inclusion)).to be(new_inclusion_helper)
    end

    it "keeps the name of a replaced built-in helper reserved" do
      collection.replace(name: :inclusion, with: new_inclusion_helper)

      expect(collection.register(inclusion_helper)).to eq(:reserved)
    end

    it "ignores a registered helper that is not built-in" do
      collection.register(positive_helper)
      collection.replace(name: :positive, with: build_helper(:positive))

      expect(collection.find_by(name: :positive)).to be(positive_helper)
    end

    it "ignores an unknown name" do
      collection.replace(name: :positive, with: positive_helper)

      expect(collection.find_by(name: :positive)).to be_nil
    end
  end

  describe "#dup" do
    it "does not share registrations with the original", :aggregate_failures do
      copy = collection.dup
      copy.register(positive_helper)

      expect(copy.find_by(name: :positive)).to be(positive_helper)
      expect(collection.find_by(name: :positive)).to be_nil
    end

    it "keeps built-in names reserved" do
      expect(collection.dup.register(build_helper(:optional))).to eq(:reserved)
    end

    context "when a helper was registered before duplication" do
      subject(:copy) { collection.dup }

      let(:another_positive_helper) { build_helper(:positive) }

      before do
        collection.register(positive_helper)
        collection.register(build_helper(:negative))
      end

      it "replaces the helper in place", :aggregate_failures do
        expect(copy.register(another_positive_helper)).to eq(:registered)
        expect(copy.map(&:name)).to eq(%i[optional inclusion positive negative])
        expect(copy.find_by(name: :positive)).to be(another_positive_helper)
      end

      it "keeps the helper in the original" do
        copy.register(another_positive_helper)

        expect(collection.find_by(name: :positive)).to be(positive_helper)
      end

      it "rejects a second replacement" do
        copy.register(another_positive_helper)

        expect(copy.register(build_helper(:positive))).to eq(:duplicated)
      end

      it "rejects a replacement after the very same helper is registered again" do
        copy.register(positive_helper)

        expect(copy.register(another_positive_helper)).to eq(:duplicated)
      end
    end
  end
end
