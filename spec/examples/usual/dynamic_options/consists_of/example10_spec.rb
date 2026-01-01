# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::ConsistsOf::Example10, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        ids:
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

    it_behaves_like "check class info",
                    inputs: %i[ids],
                    internals: %i[ids],
                    outputs: %i[ids first_id]

    describe "validations" do
      describe "inputs" do
        # NOTE: In this example, collection mode is disabled.
        it { expect { perform }.to have_input(:ids).valid_with(attributes).type(Array).required }
      end

      describe "outputs" do
        it { expect(perform).to have_output(:ids?).contains(true) }

        it do
          expect(perform).to(
            have_output(:ids).contains(["6e6ff7d9-6980-4c98-8fd8-ca615ccebab3", 123, "", :identifier, nil, 12.3])
          )
        end

        it { expect(perform).to have_output(:first_id?).contains(true) }
        it { expect(perform).to have_output(:first_id).contains("6e6ff7d9-6980-4c98-8fd8-ca615ccebab3") }
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        ids:
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

    it_behaves_like "check class info",
                    inputs: %i[ids],
                    internals: %i[ids],
                    outputs: %i[ids first_id]

    describe "validations" do
      describe "inputs" do
        # NOTE: In this example, collection mode is disabled.
        it { expect { perform }.to have_input(:ids).valid_with(attributes).type(Array).required }
      end

      describe "outputs" do
        it { expect(perform).to have_output(:ids?).contains(true) }

        it do
          expect(perform).to(
            have_output(:ids).contains(["6e6ff7d9-6980-4c98-8fd8-ca615ccebab3", 123, "", :identifier, nil, 12.3])
          )
        end

        it { expect(perform).to have_output(:first_id?).contains(true) }
        it { expect(perform).to have_output(:first_id).contains("6e6ff7d9-6980-4c98-8fd8-ca615ccebab3") }
      end
    end
  end
end
