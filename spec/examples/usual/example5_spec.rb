# frozen_string_literal: true

RSpec.describe Usual::Example5 do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        ids: ids
      }
    end

    let(:ids) do
      %w[
        6e6ff7d9-6980-4c98-8fd8-ca615ccebab3
        bdd30bb6-c6ab-448d-8302-7018de07b9a4
        e864b5e7-e515-4d5e-9a7e-7da440323390
        b0f7c462-86a4-4e5b-8d56-5dcfcabe0f81
      ]
    end

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        it "returns the expected value in `first_id`" do
          result = perform

          expect(result.first_id).to eq("6e6ff7d9-6980-4c98-8fd8-ca615ccebab3")
        end
      end
    end

    context "when the input arguments are invalid" do
      context "when `ids`" do
        it_behaves_like "input required check", name: :ids
        it_behaves_like "input type check", name: :ids, expected_type: Array
      end
    end
  end
end
