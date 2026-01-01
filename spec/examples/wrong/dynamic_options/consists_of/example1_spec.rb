# frozen_string_literal: true

RSpec.describe Wrong::DynamicOptions::ConsistsOf::Example1, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        ids:
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

    it_behaves_like "check class info",
                    inputs: %i[ids],
                    internals: %i[ids],
                    outputs: %i[]

    describe "but the data required for work is invalid" do
      it "returns expected error" do
        expect { perform }.to(
          raise_error(
            ApplicationService::Exceptions::Internal,
            "[Wrong::DynamicOptions::ConsistsOf::Example1] Wrong type of internal attribute `ids`, " \
            "expected `Set`, got `Array`"
          )
        )
      end
    end

    context "when the input arguments are invalid" do
      it do
        expect { perform }.to(
          have_input(:ids)
            .valid_with(attributes)
            .type(Array)
            .required
        )
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
      %w[
        6e6ff7d9-6980-4c98-8fd8-ca615ccebab3
        bdd30bb6-c6ab-448d-8302-7018de07b9a4
        e864b5e7-e515-4d5e-9a7e-7da440323390
        b0f7c462-86a4-4e5b-8d56-5dcfcabe0f81
      ]
    end

    it_behaves_like "check class info",
                    inputs: %i[ids],
                    internals: %i[ids],
                    outputs: %i[]

    describe "but the data required for work is invalid" do
      it "returns expected error" do
        expect { perform }.to(
          raise_error(
            ApplicationService::Exceptions::Internal,
            "[Wrong::DynamicOptions::ConsistsOf::Example1] Wrong type of internal attribute `ids`, " \
            "expected `Set`, got `Array`"
          )
        )
      end
    end

    context "when the input arguments are invalid" do
      it do
        expect { perform }.to(
          have_input(:ids)
            .valid_with(attributes)
            .type(Array)
            .required
        )
      end
    end
  end
end
