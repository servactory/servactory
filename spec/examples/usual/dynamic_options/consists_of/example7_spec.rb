# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::ConsistsOf::Example7, type: :service do
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
                    outputs: %i[ids first_id]

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:ids)
              .valid_with(attributes)
              .type(Array)
              .consists_of(String, Integer)
              .required
          )
        end
      end

      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:ids)
              .instance_of(Array)
          )
        end

        it do
          expect(perform).to(
            have_output(:first_id)
              .instance_of(String)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      context "when `ids` is `String`" do
        it do
          expect(perform).to(
            have_output(:ids?).contains(true)
          )
        end

        it do
          expect(perform).to(
            be_success_service
              .with_output(:ids, %w[
                             6e6ff7d9-6980-4c98-8fd8-ca615ccebab3
                             bdd30bb6-c6ab-448d-8302-7018de07b9a4
                             e864b5e7-e515-4d5e-9a7e-7da440323390
                             b0f7c462-86a4-4e5b-8d56-5dcfcabe0f81
                           ])
          )
        end

        it do
          expect(perform).to(
            have_output(:first_id?).contains(true)
          )
        end

        it do
          expect(perform).to(
            be_success_service
              .with_output(:first_id, "6e6ff7d9-6980-4c98-8fd8-ca615ccebab3")
          )
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

        it do
          expect(perform).to(
            have_output(:ids?).contains(true)
          )
        end

        it do
          expect(perform).to(
            be_success_service
              .with_output(:ids, [123, 456, 789])
          )
        end

        it do
          expect(perform).to(
            have_output(:first_id?).contains(true)
          )
        end

        it do
          expect(perform).to(
            be_success_service
              .with_output(:first_id, 123)
          )
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
              "[Usual::DynamicOptions::ConsistsOf::Example7] Required element in input collection `ids` is missing"
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
              "[Usual::DynamicOptions::ConsistsOf::Example7] Required element in input collection `ids` is missing"
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
                    outputs: %i[ids first_id]

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:ids)
              .valid_with(attributes)
              .type(Array)
              .consists_of(String, Integer)
              .required
          )
        end
      end

      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:ids)
              .instance_of(Array)
          )
        end

        it do
          expect(perform).to(
            have_output(:first_id)
              .instance_of(String)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      context "when `ids` is `String`" do
        it do
          expect(perform).to(
            have_output(:ids?).contains(true)
          )
        end

        it do
          expect(perform).to(
            be_success_service
              .with_output(:ids, %w[
                             6e6ff7d9-6980-4c98-8fd8-ca615ccebab3
                             bdd30bb6-c6ab-448d-8302-7018de07b9a4
                             e864b5e7-e515-4d5e-9a7e-7da440323390
                             b0f7c462-86a4-4e5b-8d56-5dcfcabe0f81
                           ])
          )
        end

        it do
          expect(perform).to(
            have_output(:first_id?).contains(true)
          )
        end

        it do
          expect(perform).to(
            be_success_service
              .with_output(:first_id, "6e6ff7d9-6980-4c98-8fd8-ca615ccebab3")
          )
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

        it do
          expect(perform).to(
            have_output(:ids?).contains(true)
          )
        end

        it do
          expect(perform).to(
            be_success_service
              .with_output(:ids, [123, 456, 789])
          )
        end

        it do
          expect(perform).to(
            have_output(:first_id?).contains(true)
          )
        end

        it do
          expect(perform).to(
            be_success_service
              .with_output(:first_id, 123)
          )
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
              "[Usual::DynamicOptions::ConsistsOf::Example7] Required element in input collection `ids` is missing"
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
              "[Usual::DynamicOptions::ConsistsOf::Example7] Required element in input collection `ids` is missing"
            )
          )
        end
      end
    end
  end
end
