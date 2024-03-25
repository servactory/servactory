# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::ConsistsOf::Example10 do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        ids: ids
      }
    end

    let(:ids) do
      [
        "6e6ff7d9-6980-4c98-8fd8-ca615ccebab3",
        123,
        "",
        :identifier,
        nil,
        12.3
      ]
    end

    include_examples "check class info",
                     inputs: %i[ids],
                     internals: %i[ids],
                     outputs: %i[ids first_id]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        include_examples "success result class"

        it "returns expected values", :aggregate_failures do
          result = perform

          expect(result.ids?).to be(true)
          expect(result.ids).to(
            contain_exactly("6e6ff7d9-6980-4c98-8fd8-ca615ccebab3", 123, "", :identifier, nil, 12.3)
          )
          expect(result.first_id?).to be(true)
          expect(result.first_id).to eq("6e6ff7d9-6980-4c98-8fd8-ca615ccebab3")
        end
      end
    end

    context "when the input arguments are invalid" do
      context "when `ids`" do
        it_behaves_like "input required check", name: :ids

        # NOTE: In this example, collection mode is disabled.
        it_behaves_like "input type check", name: :ids, expected_type: Array
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        ids: ids
      }
    end

    let(:ids) do
      [
        "6e6ff7d9-6980-4c98-8fd8-ca615ccebab3",
        123,
        "",
        :identifier,
        nil,
        12.3
      ]
    end

    include_examples "check class info",
                     inputs: %i[ids],
                     internals: %i[ids],
                     outputs: %i[ids first_id]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        include_examples "success result class"

        it "returns expected values", :aggregate_failures do
          result = perform

          expect(result.ids?).to be(true)
          expect(result.ids).to(
            contain_exactly("6e6ff7d9-6980-4c98-8fd8-ca615ccebab3", 123, "", :identifier, nil, 12.3)
          )
          expect(result.first_id?).to be(true)
          expect(result.first_id).to eq("6e6ff7d9-6980-4c98-8fd8-ca615ccebab3")
        end
      end
    end

    context "when the input arguments are invalid" do
      context "when `ids`" do
        it_behaves_like "input required check", name: :ids

        # NOTE: In this example, collection mode is disabled.
        it_behaves_like "input type check", name: :ids, expected_type: Array
      end
    end
  end
end
