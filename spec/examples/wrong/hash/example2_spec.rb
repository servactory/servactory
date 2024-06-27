# frozen_string_literal: true

RSpec.describe Wrong::Hash::Example2, type: :service do
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

    include_examples "check class info",
                     inputs: %i[payload],
                     internals: %i[],
                     outputs: %i[]

    context "when the input arguments are valid" do
      describe "but the data required for work is invalid" do
        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "[Wrong::Hash::Example2] Wrong type in input hash `payload`, expected `Hash` for `user`, got `NilClass`"
            )
          )
        end
      end
    end

    context "when the input arguments are invalid" do
      it { expect { perform }.to have_input(:payload).valid_with(false).type(Hash).required }
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

    let(:first_name) { "John" }
    let(:middle_name) { 123 }
    let(:last_name) { "Kennedy" }

    include_examples "check class info",
                     inputs: %i[payload],
                     internals: %i[],
                     outputs: %i[]

    context "when the input arguments are valid" do
      describe "but the data required for work is invalid" do
        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "[Wrong::Hash::Example2] Wrong type in input hash `payload`, expected `Hash` for `user`, got `NilClass`"
            )
          )
        end
      end
    end

    context "when the input arguments are invalid" do
      it { expect { perform }.to have_input(:payload).valid_with(false).type(Hash).required }
    end
  end
end
