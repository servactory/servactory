# frozen_string_literal: true

RSpec.describe Usual::Example13 do
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

    context "when the input attributes are valid" do
      describe "and the data required for work is also valid" do
        include_examples "success result class"

        it "returns the expected value in `first_id`" do
          result = perform

          expect(result.first_id).to eq("6e6ff7d9-6980-4c98-8fd8-ca615ccebab3")
        end
      end

      describe "but the data required for work is invalid" do
        describe "because one element has the wrong type" do
          let(:ids) do
            [
              "6e6ff7d9-6980-4c98-8fd8-ca615ccebab3",
              123,
              "bdd30bb6-c6ab-448d-8302-7018de07b9a4"
            ]
          end

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Errors::InputAttributeError,
                "Input `ids` must be an array of `String`"
              )
            )
          end
        end

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
                ApplicationService::Errors::InputAttributeError,
                "[Usual::Example13] Required element in input array `ids` is missing"
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
                ApplicationService::Errors::InputAttributeError,
                "[Usual::Example13] Required element in input array `ids` is missing"
              )
            )
          end
        end
      end
    end

    context "when the input attributes are invalid" do
      context "when `ids`" do
        it_behaves_like "input required check", name: :ids

        it_behaves_like "input type check",
                        name: :ids,
                        array: true,
                        array_message: "Input `ids` must be an array of `String`",
                        expected_type: String
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
      %w[
        6e6ff7d9-6980-4c98-8fd8-ca615ccebab3
        bdd30bb6-c6ab-448d-8302-7018de07b9a4
        e864b5e7-e515-4d5e-9a7e-7da440323390
        b0f7c462-86a4-4e5b-8d56-5dcfcabe0f81
      ]
    end

    context "when the input attributes are valid" do
      describe "and the data required for work is also valid" do
        include_examples "success result class"

        it "returns the expected value in `first_id`" do
          result = perform

          expect(result.first_id).to eq("6e6ff7d9-6980-4c98-8fd8-ca615ccebab3")
        end
      end

      describe "but the data required for work is invalid" do
        describe "because one element has the wrong type" do
          let(:ids) do
            [
              "6e6ff7d9-6980-4c98-8fd8-ca615ccebab3",
              123,
              "bdd30bb6-c6ab-448d-8302-7018de07b9a4"
            ]
          end

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Errors::InputAttributeError,
                "Input `ids` must be an array of `String`"
              )
            )
          end
        end

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
                ApplicationService::Errors::InputAttributeError,
                "[Usual::Example13] Required element in input array `ids` is missing"
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
                ApplicationService::Errors::InputAttributeError,
                "[Usual::Example13] Required element in input array `ids` is missing"
              )
            )
          end
        end
      end
    end

    context "when the input attributes are invalid" do
      context "when `ids`" do
        it_behaves_like "input required check", name: :ids

        it_behaves_like "input type check",
                        name: :ids,
                        array: true,
                        array_message: "Input `ids` must be an array of `String`",
                        expected_type: String
      end
    end
  end
end
