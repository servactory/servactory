# frozen_string_literal: true

RSpec.describe Usual::Collection::Example19, type: :service do
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

        it { expect(perform).to have_output(:ids?).with(true) }

        it do
          expect(perform).to(
            have_output(:ids).with(["6e6ff7d9-6980-4c98-8fd8-ca615ccebab3", 123, "", :identifier, nil, 12.3])
          )
        end

        it { expect(perform).to have_output(:first_id?).with(true) }
        it { expect(perform).to have_output(:first_id).with("6e6ff7d9-6980-4c98-8fd8-ca615ccebab3") }
      end
    end

    context "when the input arguments are invalid" do
      # NOTE: In this example, collection mode is disabled.
      it { expect { perform }.to have_input(:ids).direct(attributes).type(Array).required }
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

        it { expect(perform).to have_output(:ids?).with(true) }

        it do
          expect(perform).to(
            have_output(:ids).with(["6e6ff7d9-6980-4c98-8fd8-ca615ccebab3", 123, "", :identifier, nil, 12.3])
          )
        end

        it { expect(perform).to have_output(:first_id?).with(true) }
        it { expect(perform).to have_output(:first_id).with("6e6ff7d9-6980-4c98-8fd8-ca615ccebab3") }
      end
    end

    context "when the input arguments are invalid" do
      # NOTE: In this example, collection mode is disabled.
      it { expect { perform }.to have_input(:ids).direct(attributes).type(Array).required }
    end
  end
end
