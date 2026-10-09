# frozen_string_literal: true

RSpec.describe Wrong::DynamicOptions::Schema::Example17, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        payload: "John"
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
              .type(String)
              .schema({ name: { type: String } })
              .required
          )
        end
      end
    end

    describe "but the input type is not Hash-compatible" do
      it "returns expected error" do
        expect { perform }.to(
          raise_error(
            ApplicationService::Exceptions::Input,
            "Input `payload` failed with `wrong_type` for `nil`: expected `Hash`, got `String`"
          )
        )
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        payload: "John"
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
              .type(String)
              .schema({ name: { type: String } })
              .required
          )
        end
      end
    end

    describe "but the input type is not Hash-compatible" do
      it "returns expected error" do
        expect { perform }.to(
          raise_error(
            ApplicationService::Exceptions::Input,
            "Input `payload` failed with `wrong_type` for `nil`: expected `Hash`, got `String`"
          )
        )
      end
    end
  end
end
