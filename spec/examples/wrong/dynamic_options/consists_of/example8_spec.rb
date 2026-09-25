# frozen_string_literal: true

RSpec.describe Wrong::DynamicOptions::ConsistsOf::Example8, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call! }

    it_behaves_like "check class info",
                    inputs: %i[],
                    internals: %i[ids],
                    outputs: %i[]

    describe "validations" do
      describe "internals" do
        it do
          expect { perform }.to(
            have_internal(:ids)
              .type(String)
              .consists_of(String)
          )
        end
      end
    end

    describe "but the internal attribute type is not a collection" do
      it "returns expected error" do
        expect { perform }.to(
          raise_error(
            ApplicationService::Exceptions::Internal,
            "[Wrong::DynamicOptions::ConsistsOf::Example8] Wrong internal attribute collection type `ids`, " \
            "expected `Array, Set`, got `String`"
          )
        )
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call }

    it_behaves_like "check class info",
                    inputs: %i[],
                    internals: %i[ids],
                    outputs: %i[]

    describe "validations" do
      describe "internals" do
        it do
          expect { perform }.to(
            have_internal(:ids)
              .type(String)
              .consists_of(String)
          )
        end
      end
    end

    describe "but the internal attribute type is not a collection" do
      it "returns expected error" do
        expect { perform }.to(
          raise_error(
            ApplicationService::Exceptions::Internal,
            "[Wrong::DynamicOptions::ConsistsOf::Example8] Wrong internal attribute collection type `ids`, " \
            "expected `Array, Set`, got `String`"
          )
        )
      end
    end
  end
end
