# frozen_string_literal: true

RSpec.describe Wrong::DynamicOptions::Format::WrongType::Example1, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        email:
      }
    end

    let(:email) { 12_345 }

    it_behaves_like "check class info",
                    inputs: %i[email],
                    internals: %i[],
                    outputs: %i[]

    describe "but the data required for work is invalid" do
      describe "because the value type is not a String for format validation" do
        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "[Wrong::DynamicOptions::Format::WrongType::Example1] " \
              "Input `email` must be a String for `email` format validation"
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
        email:
      }
    end

    let(:email) { 12_345 }

    it_behaves_like "check class info",
                    inputs: %i[email],
                    internals: %i[],
                    outputs: %i[]

    describe "but the data required for work is invalid" do
      describe "because the value type is not a String for format validation" do
        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "[Wrong::DynamicOptions::Format::WrongType::Example1] " \
              "Input `email` must be a String for `email` format validation"
            )
          )
        end
      end
    end
  end
end
