# frozen_string_literal: true

RSpec.describe Wrong::DynamicOptions::ConsistsOf::Example12, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        ids: :id
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
              .type(String, Symbol)
              .consists_of(String)
              .required
          )
        end
      end
    end

    describe "but none of the input types is a collection" do
      it "returns expected error" do
        expect { perform }.to(
          raise_error(
            ApplicationService::Exceptions::Input,
            "[Wrong::DynamicOptions::ConsistsOf::Example12] Wrong input collection type `ids`, " \
            "expected `Array, Set, Wrong::DynamicOptions::ConsistsOf::Example12Collection`, got `String, Symbol`"
          )
        )
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        ids: :id
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
              .type(String, Symbol)
              .consists_of(String)
              .required
          )
        end
      end
    end

    describe "but none of the input types is a collection" do
      it "returns expected error" do
        expect { perform }.to(
          raise_error(
            ApplicationService::Exceptions::Input,
            "[Wrong::DynamicOptions::ConsistsOf::Example12] Wrong input collection type `ids`, " \
            "expected `Array, Set, Wrong::DynamicOptions::ConsistsOf::Example12Collection`, got `String, Symbol`"
          )
        )
      end
    end
  end
end
