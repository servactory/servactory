# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::ConsistsOf::Example12, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        ids:
      }
    end

    let(:ids) do
      Set[
        "6e6ff7d9-6980-4c98-8fd8-ca615ccebab3",
        "bdd30bb6-c6ab-448d-8302-7018de07b9a4",
        "e864b5e7-e515-4d5e-9a7e-7da440323390",
        "b0f7c462-86a4-4e5b-8d56-5dcfcabe0f81"
      ]
    end

    it_behaves_like "check class info",
                    inputs: %i[ids],
                    internals: %i[ids],
                    outputs: %i[ids first_id]

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:ids)
              .valid_with(attributes)
              .type(Set)
              .required
              .consists_of(String)
          )
        end
      end

      describe "outputs" do
        it { expect(perform).to have_output(:ids?).contains(true) }

        it do
          expect(perform).to(
            have_output(:ids)
              .contains(
                Set[
                  "6e6ff7d9-6980-4c98-8fd8-ca615ccebab3",
                  "bdd30bb6-c6ab-448d-8302-7018de07b9a4",
                  "e864b5e7-e515-4d5e-9a7e-7da440323390",
                  "b0f7c462-86a4-4e5b-8d56-5dcfcabe0f81"
                ]
              )
          )
        end

        it { expect(perform).to have_output(:first_id?).contains(true) }
        it { expect(perform).to have_output(:first_id).contains("6e6ff7d9-6980-4c98-8fd8-ca615ccebab3") }
      end
    end

    describe "but the data required for work is invalid" do
      describe "because one element has the wrong type" do
        let(:ids) do
          Set[
            "6e6ff7d9-6980-4c98-8fd8-ca615ccebab3",
            123,
            "bdd30bb6-c6ab-448d-8302-7018de07b9a4"
          ]
        end

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "[Usual::DynamicOptions::ConsistsOf::Example12] Wrong element type in input collection `ids`, " \
              "expected `String`, got `Integer`"
            )
          )
        end
      end

      describe "because one element is empty" do
        let(:ids) do
          Set[
            "6e6ff7d9-6980-4c98-8fd8-ca615ccebab3",
            "",
            "bdd30bb6-c6ab-448d-8302-7018de07b9a4"
          ]
        end

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "[Usual::DynamicOptions::ConsistsOf::Example12] Required element in input collection `ids` is missing"
            )
          )
        end
      end

      describe "because one element is nil" do
        let(:ids) do
          Set[
            "6e6ff7d9-6980-4c98-8fd8-ca615ccebab3",
            nil,
            "bdd30bb6-c6ab-448d-8302-7018de07b9a4"
          ]
        end

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "[Usual::DynamicOptions::ConsistsOf::Example12] Required element in input collection `ids` is missing"
            )
          )
        end
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
      Set[
        "6e6ff7d9-6980-4c98-8fd8-ca615ccebab3",
        "bdd30bb6-c6ab-448d-8302-7018de07b9a4",
        "e864b5e7-e515-4d5e-9a7e-7da440323390",
        "b0f7c462-86a4-4e5b-8d56-5dcfcabe0f81"
      ]
    end

    it_behaves_like "check class info",
                    inputs: %i[ids],
                    internals: %i[ids],
                    outputs: %i[ids first_id]

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:ids)
              .valid_with(attributes)
              .type(Set)
              .required
              .consists_of(String)
          )
        end
      end

      describe "outputs" do
        it { expect(perform).to have_output(:ids?).contains(true) }

        it do
          expect(perform).to(
            have_output(:ids)
              .contains(
                Set[
                  "6e6ff7d9-6980-4c98-8fd8-ca615ccebab3",
                  "bdd30bb6-c6ab-448d-8302-7018de07b9a4",
                  "e864b5e7-e515-4d5e-9a7e-7da440323390",
                  "b0f7c462-86a4-4e5b-8d56-5dcfcabe0f81"
                ]
              )
          )
        end

        it { expect(perform).to have_output(:first_id?).contains(true) }
        it { expect(perform).to have_output(:first_id).contains("6e6ff7d9-6980-4c98-8fd8-ca615ccebab3") }
      end
    end

    describe "but the data required for work is invalid" do
      describe "because one element has the wrong type" do
        let(:ids) do
          Set[
            "6e6ff7d9-6980-4c98-8fd8-ca615ccebab3",
            123,
            "bdd30bb6-c6ab-448d-8302-7018de07b9a4"
          ]
        end

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "[Usual::DynamicOptions::ConsistsOf::Example12] Wrong element type in input collection `ids`, " \
              "expected `String`, got `Integer`"
            )
          )
        end
      end

      describe "because one element is empty" do
        let(:ids) do
          Set[
            "6e6ff7d9-6980-4c98-8fd8-ca615ccebab3",
            "",
            "bdd30bb6-c6ab-448d-8302-7018de07b9a4"
          ]
        end

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "[Usual::DynamicOptions::ConsistsOf::Example12] Required element in input collection `ids` is missing"
            )
          )
        end
      end

      describe "because one element is nil" do
        let(:ids) do
          Set[
            "6e6ff7d9-6980-4c98-8fd8-ca615ccebab3",
            nil,
            "bdd30bb6-c6ab-448d-8302-7018de07b9a4"
          ]
        end

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "[Usual::DynamicOptions::ConsistsOf::Example12] Required element in input collection `ids` is missing"
            )
          )
        end
      end
    end
  end
end
