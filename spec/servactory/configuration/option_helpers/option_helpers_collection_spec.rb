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

  describe "#<<" do
    let(:reserved_error_message) do
      "The `optional` option helper name is reserved by a built-in option helper. " \
        "See configuration example here: https://servactory.com/guide/configuration"
    end

    let(:duplicated_error_message) do
      "The `positive` option helper is already registered in this collection. " \
        "See configuration example here: https://servactory.com/guide/configuration"
    end

    context "when the name is new" do
      it "returns the collection" do
        expect(collection << positive_helper).to be(collection)
      end

      it "appends the helper" do
        collection << positive_helper

        expect(collection.map(&:name)).to eq(%i[optional inclusion positive])
      end

      it "supports chaining" do
        collection << positive_helper << build_helper(:negative)

        expect(collection.map(&:name)).to eq(%i[optional inclusion positive negative])
      end
    end

    context "when the very same helper is already registered" do
      before { collection << positive_helper }

      it "keeps the collection unchanged" do
        collection << positive_helper

        expect(collection.to_a).to eq([optional_helper, inclusion_helper, positive_helper])
      end
    end

    context "when the very same built-in helper is added" do
      it "keeps the collection unchanged" do
        collection << optional_helper

        expect(collection.to_a).to eq([optional_helper, inclusion_helper])
      end
    end

    context "when the name belongs to a built-in helper" do
      let(:custom_optional_helper) { build_helper(:optional) }

      it "raises an error" do
        expect { collection << custom_optional_helper }.to raise_error(ArgumentError, reserved_error_message)
      end

      it "keeps the built-in helper", :aggregate_failures do
        expect { collection << custom_optional_helper }.to raise_error(ArgumentError)

        expect(collection.find_by(name: :optional)).to be(optional_helper)
      end
    end

    context "when another helper with the name is already registered" do
      let(:another_positive_helper) { build_helper(:positive) }

      before { collection << positive_helper }

      it "raises an error" do
        expect { collection << another_positive_helper }.to raise_error(ArgumentError, duplicated_error_message)
      end

      it "keeps the first helper", :aggregate_failures do
        expect { collection << another_positive_helper }.to raise_error(ArgumentError)

        expect(collection.find_by(name: :positive)).to be(positive_helper)
      end
    end

    context "when a helper was registered before duplication" do
      subject(:copy) { collection.dup }

      let(:another_positive_helper) { build_helper(:positive) }

      before { collection << positive_helper }

      it "replaces the helper in the duplicate only", :aggregate_failures do
        copy << another_positive_helper

        expect(copy.find_by(name: :positive)).to be(another_positive_helper)
        expect(collection.find_by(name: :positive)).to be(positive_helper)
      end

      it "raises an error for a second replacement" do
        copy << another_positive_helper

        expect { copy << build_helper(:positive) }.to raise_error(ArgumentError, duplicated_error_message)
      end
    end

    context "when used through the configuration of a service class" do
      let(:service_class) do
        helper = Servactory::Maintenance::Options::Helper.new(
          name: :positive,
          equivalent: {
            must: { be_positive: { is: ->(value:, **) { value.positive? }, message: "Must be positive" } }
          }
        )

        Class.new(ApplicationService::Base) do
          config.input_option_helpers << helper

          input :number, :positive, type: Integer

          output :number, type: Integer

          private

          def call
            outputs.number = inputs.number
          end
        end
      end

      it "applies the helper to attributes declared afterwards", :aggregate_failures do
        expect(service_class.call!(number: 1)).to have_attributes(number: 1)
        expect { service_class.call!(number: -1) }.to raise_error(
          ApplicationService::Exceptions::Input,
          "Must be positive"
        )
      end

      it "keeps the configuration of the parent class" do
        service_class

        expect(ApplicationService::Base.config.input_option_helpers.find_by(name: :positive)).to be_nil
      end
    end
  end

  describe "#merge" do
    let(:negative_helper) { build_helper(:negative) }

    context "when the names are new" do
      it "returns the collection" do
        expect(collection.merge([positive_helper])).to be(collection)
      end

      it "appends the helpers in order" do
        collection.merge([positive_helper, negative_helper])

        expect(collection.map(&:name)).to eq(%i[optional inclusion positive negative])
      end

      it "accepts several enumerables" do
        collection.merge([positive_helper], Set[negative_helper])

        expect(collection.map(&:name)).to eq(%i[optional inclusion positive negative])
      end
    end

    context "when the very same helpers are merged again" do
      before { collection.merge([positive_helper, negative_helper]) }

      it "keeps the collection unchanged" do
        collection.merge([positive_helper, optional_helper, negative_helper])

        expect(collection.to_a).to eq([optional_helper, inclusion_helper, positive_helper, negative_helper])
      end
    end

    context "when a name belongs to a built-in helper" do
      it "raises an error" do
        expect { collection.merge([positive_helper, build_helper(:inclusion)]) }.to raise_error(
          ArgumentError,
          /The `inclusion` option helper name is reserved by a built-in option helper/
        )
      end

      it "keeps the helpers preceding the rejected one", :aggregate_failures do
        expect { collection.merge([positive_helper, build_helper(:inclusion)]) }.to raise_error(ArgumentError)

        expect(collection.map(&:name)).to eq(%i[optional inclusion positive])
      end
    end

    context "when two helpers share a name" do
      it "raises an error" do
        expect { collection.merge([positive_helper, build_helper(:positive)]) }.to raise_error(
          ArgumentError,
          /The `positive` option helper is already registered in this collection/
        )
      end
    end

    context "when helpers were registered before duplication" do
      subject(:copy) { collection.dup }

      let(:another_positive_helper) { build_helper(:positive) }

      before { collection.merge([positive_helper, negative_helper]) }

      it "replaces them in the duplicate keeping their positions", :aggregate_failures do
        copy.merge([another_positive_helper])

        expect(copy.to_a).to eq([optional_helper, inclusion_helper, another_positive_helper, negative_helper])
        expect(collection.find_by(name: :positive)).to be(positive_helper)
      end
    end
  end

  describe "Enumerable methods" do
    it "returns an Array from #filter" do
      expect(collection.filter(&:dynamic_option?)).to eq([inclusion_helper])
    end

    it "returns an Array from #map" do
      expect(collection.map(&:name)).to eq(%i[optional inclusion])
    end

    it "returns the memo from #each_with_object" do
      names = collection.each_with_object(Set.new) { |helper, memo| memo << helper.name }

      expect(names).to eq(Set[:optional, :inclusion])
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
