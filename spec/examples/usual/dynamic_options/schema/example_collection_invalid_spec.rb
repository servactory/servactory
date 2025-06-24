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
      expect { perform }.to raise_error(ApplicationService::Exceptions::Input, "[Usual::DynamicOptions::Schema::ExampleCollectionInvalid] Wrong element in input collection `items` at index 1: required")
    end
  end
end 