# frozen_string_literal: true

RSpec.describe Wrong::DynamicOptions::Format::WrongType::Example4, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        value:
      }
    end

    let(:value) { 12_345 }

    it_behaves_like "check class info",
                    inputs: %i[value],
                    internals: %i[],
                    outputs: %i[email]

    describe "but the data required for work is invalid" do
      describe "because the value type is not a String for format validation" do
        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Output,
              "[Wrong::DynamicOptions::Format::WrongType::Example4] " \
              "Output attribute `email` must be a String for `email` format validation"
            )
          )
        end
      end
    end

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:value)
              .valid_with(attributes)
              .type(Integer)
              .required
          )
        end
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        value:
      }
    end

    let(:value) { 12_345 }

    it_behaves_like "check class info",
                    inputs: %i[value],
                    internals: %i[],
                    outputs: %i[email]

    describe "but the data required for work is invalid" do
      describe "because the value type is not a String for format validation" do
        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Output,
              "[Wrong::DynamicOptions::Format::WrongType::Example4] " \
              "Output attribute `email` must be a String for `email` format validation"
            )
          )
        end
      end
    end

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:value)
              .valid_with(attributes)
              .type(Integer)
              .required
          )
        end
      end
    end
  end
end
