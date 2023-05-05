# frozen_string_literal: true

RSpec.describe Wrong::Example8 do
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
      describe "but the data required for work is invalid" do
        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Errors::InputArgumentError,
              "[Wrong::Example8] Conflict in `ids` input options: `array_vs_array`"
            )
          )
        end
      end
    end

    context "when the input arguments are invalid" do
      context "when `ids`" do
        describe "is not passed" do
          let(:ids) { nil }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Errors::InputArgumentError,
                "[Wrong::Example8] Conflict in `ids` input options: `array_vs_array`"
              )
            )
          end
        end

        describe "is of the wrong type" do
          let(:ids) { 123 }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Errors::InputArgumentError,
                "[Wrong::Example8] Conflict in `ids` input options: `array_vs_array`"
              )
            )
          end
        end
      end
    end
  end
end
