# frozen_string_literal: true

RSpec.describe Wrong::DynamicOptions::Schema::Example18, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        payload: :john
      }
    end

    it_behaves_like "check class info",
                    inputs: %i[payload],
                    internals: %i[],
                    outputs: %i[]

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:payload)
              .type(String, Symbol)
              .schema({ name: { type: String } })
              .required
          )
        end
      end
    end

    describe "but none of the input types is Hash-compatible" do
      it "returns expected error" do
        expect { perform }.to(
          raise_error(
            ApplicationService::Exceptions::Input,
            "[Wrong::DynamicOptions::Schema::Example18] Wrong type of input `payload`, " \
            "expected `Hash, Wrong::DynamicOptions::Schema::Example18Payload`, got `String, Symbol`"
          )
        )
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        payload: :john
      }
    end

    it_behaves_like "check class info",
                    inputs: %i[payload],
                    internals: %i[],
                    outputs: %i[]

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:payload)
              .type(String, Symbol)
              .schema({ name: { type: String } })
              .required
          )
        end
      end
    end

    describe "but none of the input types is Hash-compatible" do
      it "returns expected error" do
        expect { perform }.to(
          raise_error(
            ApplicationService::Exceptions::Input,
            "[Wrong::DynamicOptions::Schema::Example18] Wrong type of input `payload`, " \
            "expected `Hash, Wrong::DynamicOptions::Schema::Example18Payload`, got `String, Symbol`"
          )
        )
      end
    end
  end
end
