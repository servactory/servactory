# frozen_string_literal: true

RSpec.describe Wrong::DynamicOptions::MultipleOf::Example2, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        number:
      }
    end

    let(:number) { 10 }

    it_behaves_like "check class info",
                    inputs: %i[number],
                    internals: %i[],
                    outputs: %i[]

    context "when the input arguments are valid" do
      describe "but the data required for work is invalid" do
        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "[Wrong::DynamicOptions::MultipleOf::Example2] " \
              "Input `number` has an invalid value `0` in option `multiple_of`"
            )
          )
        end
      end
    end

    # NOTE: Will not work due to division by 0.
    # context "when the input arguments are invalid" do
    #   it { expect { perform }.to have_input(:number).valid_with(attributes).type(Integer).required }
    # end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        number:
      }
    end

    let(:number) { 10 }

    it_behaves_like "check class info",
                    inputs: %i[number],
                    internals: %i[],
                    outputs: %i[]

    context "when the input arguments are valid" do
      describe "but the data required for work is invalid" do
        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "[Wrong::DynamicOptions::MultipleOf::Example2] " \
              "Input `number` has an invalid value `0` in option `multiple_of`"
            )
          )
        end
      end
    end

    # NOTE: Will not work due to division by 0.
    # context "when the input arguments are invalid" do
    #   it { expect { perform }.to have_input(:number).valid_with(attributes).type(Integer).required }
    # end
  end
end
