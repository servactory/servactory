# frozen_string_literal: true

RSpec.describe Wrong::DynamicOptions::ConsistsOf::Example7, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        ids: "6e6ff7d9-6980-4c98-8fd8-ca615ccebab3"
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
              .type(String)
              .consists_of(String)
              .required
          )
        end
      end
    end

    describe "but the input type is not a collection" do
      it "returns expected error" do
        expect { perform }.to(
          raise_error(
            ApplicationService::Exceptions::Input,
            "[Wrong::DynamicOptions::ConsistsOf::Example7] Wrong input collection type `ids`, " \
            "expected `Array, Set`, got `String`"
          )
        )
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        ids: "6e6ff7d9-6980-4c98-8fd8-ca615ccebab3"
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
              .type(String)
              .consists_of(String)
              .required
          )
        end
      end
    end

    describe "but the input type is not a collection" do
      it "returns expected error" do
        expect { perform }.to(
          raise_error(
            ApplicationService::Exceptions::Input,
            "[Wrong::DynamicOptions::ConsistsOf::Example7] Wrong input collection type `ids`, " \
            "expected `Array, Set`, got `String`"
          )
        )
      end
    end
  end
end
