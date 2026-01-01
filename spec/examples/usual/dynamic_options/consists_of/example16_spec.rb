# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::ConsistsOf::Example16, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        ids:
      }
    end

    let(:ids) do
      Set[]
    end

    it_behaves_like "check class info",
                    inputs: %i[ids],
                    internals: %i[ids],
                    outputs: %i[ids]

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:ids)
              .valid_with(attributes)
              .type(Set)
              .consists_of(String)
              .optional
          )
        end
      end

      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:ids)
              .instance_of(Set)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          have_output(:ids?).contains(false)
        )
      end

      it do
        expect(perform).to(
          be_success_service
            .with_output(:ids, Set.new)
        )
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
              "[Usual::DynamicOptions::ConsistsOf::Example16] Wrong element type in input collection `ids`, " \
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
              "[Usual::DynamicOptions::ConsistsOf::Example16] Required element in input collection `ids` is missing"
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
              "[Usual::DynamicOptions::ConsistsOf::Example16] Required element in input collection `ids` is missing"
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
      Set[]
    end

    it_behaves_like "check class info",
                    inputs: %i[ids],
                    internals: %i[ids],
                    outputs: %i[ids]

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:ids)
              .valid_with(attributes)
              .type(Set)
              .consists_of(String)
              .optional
          )
        end
      end

      describe "outputs" do
        it do
          expect(perform).to(
            have_output(:ids)
              .instance_of(Set)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          have_output(:ids?).contains(false)
        )
      end

      it do
        expect(perform).to(
          be_success_service
            .with_output(:ids, Set.new)
        )
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
              "[Usual::DynamicOptions::ConsistsOf::Example16] Wrong element type in input collection `ids`, " \
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
              "[Usual::DynamicOptions::ConsistsOf::Example16] Required element in input collection `ids` is missing"
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
              "[Usual::DynamicOptions::ConsistsOf::Example16] Required element in input collection `ids` is missing"
            )
          )
        end
      end
    end
  end
end
