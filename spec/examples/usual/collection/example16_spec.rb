# frozen_string_literal: true

RSpec.describe Usual::Collection::Example16, type: :service do
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

    include_examples "check class info",
                     inputs: %i[ids],
                     internals: %i[ids],
                     outputs: %i[ids first_id]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        include_examples "success result class"

        context "when `ids` is `String`" do
          it "returns expected values", :aggregate_failures do
            result = perform

            expect(result.ids?).to be(true)
            expect(result.ids).to(
              match_array(
                %w[
                  6e6ff7d9-6980-4c98-8fd8-ca615ccebab3
                  bdd30bb6-c6ab-448d-8302-7018de07b9a4
                  e864b5e7-e515-4d5e-9a7e-7da440323390
                  b0f7c462-86a4-4e5b-8d56-5dcfcabe0f81
                ]
              )
            )
            expect(result.first_id?).to be(true)
            expect(result.first_id).to eq("6e6ff7d9-6980-4c98-8fd8-ca615ccebab3")
          end
        end

        context "when `ids` is `Integer`" do
          let(:ids) do
            [
              123,
              456,
              789
            ]
          end

          it "returns expected values", :aggregate_failures do
            result = perform

            expect(result.ids?).to be(true)
            expect(result.ids).to(
              contain_exactly(123, 456, 789)
            )
            expect(result.first_id?).to be(true)
            expect(result.first_id).to eq(123)
          end
        end
      end

      describe "but the data required for work is invalid" do
        describe "because one element is empty" do
          let(:ids) do
            [
              "6e6ff7d9-6980-4c98-8fd8-ca615ccebab3",
              "",
              "bdd30bb6-c6ab-448d-8302-7018de07b9a4"
            ]
          end

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Input,
                "[Usual::Collection::Example16] Required element in input collection `ids` is missing"
              )
            )
          end
        end

        describe "because one element is nil" do
          let(:ids) do
            [
              "6e6ff7d9-6980-4c98-8fd8-ca615ccebab3",
              nil,
              "bdd30bb6-c6ab-448d-8302-7018de07b9a4"
            ]
          end

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Input,
                "[Usual::Collection::Example16] Required element in input collection `ids` is missing"
              )
            )
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      it { expect { perform }.to have_input(:ids).type(Array).consists_of(String, Integer).required }
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
      %w[
        6e6ff7d9-6980-4c98-8fd8-ca615ccebab3
        bdd30bb6-c6ab-448d-8302-7018de07b9a4
        e864b5e7-e515-4d5e-9a7e-7da440323390
        b0f7c462-86a4-4e5b-8d56-5dcfcabe0f81
      ]
    end

    include_examples "check class info",
                     inputs: %i[ids],
                     internals: %i[ids],
                     outputs: %i[ids first_id]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        include_examples "success result class"

        context "when `ids` is `String`" do
          it "returns expected values", :aggregate_failures do
            result = perform

            expect(result.ids?).to be(true)
            expect(result.ids).to(
              match_array(
                %w[
                  6e6ff7d9-6980-4c98-8fd8-ca615ccebab3
                  bdd30bb6-c6ab-448d-8302-7018de07b9a4
                  e864b5e7-e515-4d5e-9a7e-7da440323390
                  b0f7c462-86a4-4e5b-8d56-5dcfcabe0f81
                ]
              )
            )
            expect(result.first_id?).to be(true)
            expect(result.first_id).to eq("6e6ff7d9-6980-4c98-8fd8-ca615ccebab3")
          end
        end

        context "when `ids` is `Integer`" do
          let(:ids) do
            [
              123,
              456,
              789
            ]
          end

          it "returns expected values", :aggregate_failures do
            result = perform

            expect(result.ids?).to be(true)
            expect(result.ids).to(
              contain_exactly(123, 456, 789)
            )
            expect(result.first_id?).to be(true)
            expect(result.first_id).to eq(123)
          end
        end
      end

      describe "but the data required for work is invalid" do
        describe "because one element is empty" do
          let(:ids) do
            [
              "6e6ff7d9-6980-4c98-8fd8-ca615ccebab3",
              "",
              "bdd30bb6-c6ab-448d-8302-7018de07b9a4"
            ]
          end

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Input,
                "[Usual::Collection::Example16] Required element in input collection `ids` is missing"
              )
            )
          end
        end

        describe "because one element is nil" do
          let(:ids) do
            [
              "6e6ff7d9-6980-4c98-8fd8-ca615ccebab3",
              nil,
              "bdd30bb6-c6ab-448d-8302-7018de07b9a4"
            ]
          end

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Input,
                "[Usual::Collection::Example16] Required element in input collection `ids` is missing"
              )
            )
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      it { expect { perform }.to have_input(:ids).type(Array).consists_of(String, Integer).required }
    end
  end
end
