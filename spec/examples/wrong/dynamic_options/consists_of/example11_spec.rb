# frozen_string_literal: true

RSpec.describe Wrong::DynamicOptions::ConsistsOf::Example11, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        ids: Wrong::DynamicOptions::ConsistsOf::Example11Collection.new(
          %w[
            6e6ff7d9-6980-4c98-8fd8-ca615ccebab3
            bdd30bb6-c6ab-448d-8302-7018de07b9a4
          ]
        )
      }
    end

    it_behaves_like "check class info",
                    inputs: %i[ids],
                    internals: %i[],
                    outputs: %i[]

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:ids)
              .type(Wrong::DynamicOptions::ConsistsOf::Example11Collection)
              .consists_of(String)
              .required
          )
        end
      end
    end

    describe "but the input type is not configured as a collection" do
      it "returns expected error" do
        expect { perform }.to(
          raise_error(
            ApplicationService::Exceptions::Input,
            "[Wrong::DynamicOptions::ConsistsOf::Example11] Wrong input collection type `ids`, " \
            "expected `Array, Set`, got `Wrong::DynamicOptions::ConsistsOf::Example11Collection`"
          )
        )
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        ids: Wrong::DynamicOptions::ConsistsOf::Example11Collection.new(
          %w[
            6e6ff7d9-6980-4c98-8fd8-ca615ccebab3
            bdd30bb6-c6ab-448d-8302-7018de07b9a4
          ]
        )
      }
    end

    it_behaves_like "check class info",
                    inputs: %i[ids],
                    internals: %i[],
                    outputs: %i[]

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:ids)
              .type(Wrong::DynamicOptions::ConsistsOf::Example11Collection)
              .consists_of(String)
              .required
          )
        end
      end
    end

    describe "but the input type is not configured as a collection" do
      it "returns expected error" do
        expect { perform }.to(
          raise_error(
            ApplicationService::Exceptions::Input,
            "[Wrong::DynamicOptions::ConsistsOf::Example11] Wrong input collection type `ids`, " \
            "expected `Array, Set`, got `Wrong::DynamicOptions::ConsistsOf::Example11Collection`"
          )
        )
      end
    end
  end
end
