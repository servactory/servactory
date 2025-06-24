# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::Schema::ExampleCollectionInvalid, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        items: [
          { id: 1, name: "Item 1" },
          { id: 2 } # отсутствует ключ :name
        ]
      }
    end

    it "raises an error for invalid element in collection" do
      expect { perform }.to raise_error(ApplicationService::Exceptions::Input, "[Usual::DynamicOptions::Schema::ExampleCollectionInvalid] Wrong element in input collection `items`: hash element for `name` has NilClass instead of String")
    end

    it "returns an error for invalid collection element" do
      result = described_class.call(items: [{ id: "not-an-integer", name: "Test" }])
      expect(result).to be_failure
      expect(result.errors[:items]).to eq([
        "[Usual::DynamicOptions::Schema::ExampleCollectionInvalid] Wrong element in input collection `items`: hash element for `id` has String instead of Integer"
      ])
    end
  end
end 