# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::ConsistsOf::Example22, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        items:
      }
    end

    let(:items) do
      Usual::DynamicOptions::ConsistsOf::Example22Collection.new(
        "6e6ff7d9-6980-4c98-8fd8-ca615ccebab3",
        "bdd30bb6-c6ab-448d-8302-7018de07b9a4",
        "e864b5e7-e515-4d5e-9a7e-7da440323390"
      )
    end

    it_behaves_like "check class info",
                    inputs: %i[items],
                    internals: %i[],
                    outputs: %i[items]

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:items)
              .valid_with(attributes)
              .type(Usual::DynamicOptions::ConsistsOf::Example22Collection)
              .consists_of(String)
              .required
          )
        end
      end

      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:items)
              .instance_of(Usual::DynamicOptions::ConsistsOf::Example22Collection)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_outputs(
              items:,
              items?: true
            )
        )
      end
    end

    describe "but the data required for work is invalid" do
      describe "because one element has the wrong type" do
        let(:items) do
          Usual::DynamicOptions::ConsistsOf::Example22Collection.new(
            "6e6ff7d9-6980-4c98-8fd8-ca615ccebab3",
            123_456,
            "bdd30bb6-c6ab-448d-8302-7018de07b9a4"
          )
        end

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "[Usual::DynamicOptions::ConsistsOf::Example22] Wrong element type in input " \
              "collection `items`, expected `String`, got `Integer`"
            )
          )
        end
      end

      describe "because one element is empty" do
        let(:items) do
          Usual::DynamicOptions::ConsistsOf::Example22Collection.new(
            "6e6ff7d9-6980-4c98-8fd8-ca615ccebab3",
            "",
            "bdd30bb6-c6ab-448d-8302-7018de07b9a4"
          )
        end

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "[Usual::DynamicOptions::ConsistsOf::Example22] Required element in input " \
              "collection `items` is missing"
            )
          )
        end
      end

      describe "because one element is nil" do
        let(:items) do
          Usual::DynamicOptions::ConsistsOf::Example22Collection.new(
            "6e6ff7d9-6980-4c98-8fd8-ca615ccebab3",
            nil,
            "bdd30bb6-c6ab-448d-8302-7018de07b9a4"
          )
        end

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "[Usual::DynamicOptions::ConsistsOf::Example22] Required element in input " \
              "collection `items` is missing"
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
        items:
      }
    end

    let(:items) do
      Usual::DynamicOptions::ConsistsOf::Example22Collection.new(
        "6e6ff7d9-6980-4c98-8fd8-ca615ccebab3",
        "bdd30bb6-c6ab-448d-8302-7018de07b9a4",
        "e864b5e7-e515-4d5e-9a7e-7da440323390"
      )
    end

    it_behaves_like "check class info",
                    inputs: %i[items],
                    internals: %i[],
                    outputs: %i[items]

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:items)
              .valid_with(attributes)
              .type(Usual::DynamicOptions::ConsistsOf::Example22Collection)
              .consists_of(String)
              .required
          )
        end
      end

      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:items)
              .instance_of(Usual::DynamicOptions::ConsistsOf::Example22Collection)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_outputs(
              items:,
              items?: true
            )
        )
      end
    end

    describe "but the data required for work is invalid" do
      describe "because one element has the wrong type" do
        let(:items) do
          Usual::DynamicOptions::ConsistsOf::Example22Collection.new(
            "6e6ff7d9-6980-4c98-8fd8-ca615ccebab3",
            123_456,
            "bdd30bb6-c6ab-448d-8302-7018de07b9a4"
          )
        end

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "[Usual::DynamicOptions::ConsistsOf::Example22] Wrong element type in input " \
              "collection `items`, expected `String`, got `Integer`"
            )
          )
        end
      end

      describe "because one element is empty" do
        let(:items) do
          Usual::DynamicOptions::ConsistsOf::Example22Collection.new(
            "6e6ff7d9-6980-4c98-8fd8-ca615ccebab3",
            "",
            "bdd30bb6-c6ab-448d-8302-7018de07b9a4"
          )
        end

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "[Usual::DynamicOptions::ConsistsOf::Example22] Required element in input " \
              "collection `items` is missing"
            )
          )
        end
      end

      describe "because one element is nil" do
        let(:items) do
          Usual::DynamicOptions::ConsistsOf::Example22Collection.new(
            "6e6ff7d9-6980-4c98-8fd8-ca615ccebab3",
            nil,
            "bdd30bb6-c6ab-448d-8302-7018de07b9a4"
          )
        end

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "[Usual::DynamicOptions::ConsistsOf::Example22] Required element in input " \
              "collection `items` is missing"
            )
          )
        end
      end
    end
  end
end
