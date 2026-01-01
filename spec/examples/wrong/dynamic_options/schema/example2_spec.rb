# frozen_string_literal: true

RSpec.describe Wrong::DynamicOptions::Schema::Example2, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        payload:
      }
    end

    let(:payload) do
      {
        request_id: "6e6ff7d9-6980-4c98-8fd8-ca615ccebab3",
        user: nil
      }
    end

    it_behaves_like "check class info",
                    inputs: %i[payload],
                    internals: %i[],
                    outputs: %i[]

    describe "validations" do
      describe "inputs" do
        it do # rubocop:disable RSpec/ExampleLength
          expect { perform }.to(
            have_input(:payload)
              .type(Hash)
              .schema(
                {
                  request_id: { type: String, required: true },
                  user: {
                    type: Hash,
                    required: true,
                    first_name: { type: String, required: true },
                    middle_name: { type: String, required: false },
                    last_name: { type: String, required: true }
                  }
                }
              )
              .required
          )
        end
      end
    end

    describe "but the data required for work is invalid" do
      it "returns expected error" do
        expect { perform }.to(
          raise_error(
            ApplicationService::Exceptions::Input,
            "[Wrong::DynamicOptions::Schema::Example2] Wrong value in input hash `payload`, " \
            "expected value of type `Hash` for `user`, got `NilClass`"
          )
        )
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        payload:
      }
    end

    let(:payload) do
      {
        request_id: "6e6ff7d9-6980-4c98-8fd8-ca615ccebab3",
        user: nil
      }
    end

    it_behaves_like "check class info",
                    inputs: %i[payload],
                    internals: %i[],
                    outputs: %i[]

    describe "validations" do
      describe "inputs" do
        it do # rubocop:disable RSpec/ExampleLength
          expect { perform }.to(
            have_input(:payload)
              .type(Hash)
              .schema(
                {
                  request_id: { type: String, required: true },
                  user: {
                    type: Hash,
                    required: true,
                    first_name: { type: String, required: true },
                    middle_name: { type: String, required: false },
                    last_name: { type: String, required: true }
                  }
                }
              )
              .required
          )
        end
      end
    end

    describe "but the data required for work is invalid" do
      it "returns expected error" do
        expect { perform }.to(
          raise_error(
            ApplicationService::Exceptions::Input,
            "[Wrong::DynamicOptions::Schema::Example2] Wrong value in input hash `payload`, " \
            "expected value of type `Hash` for `user`, got `NilClass`"
          )
        )
      end
    end
  end
end
