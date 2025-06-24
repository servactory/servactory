# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::Schema::ExampleCollectionValid, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        items: [
          { id: 1, name: "Item 1" },
          { id: 2, name: "Item 2" }
        ]
      }
    end

    it "returns the name of the first item" do
      expect(perform.first_item_name).to eq("Item 1")
    end
  end
end 