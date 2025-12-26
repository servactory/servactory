# frozen_string_literal: true

RSpec.describe Wrong::DynamicOptions::Format::WrongType::Example2, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        identifier:
      }
    end

    let(:identifier) { { key: "value" } }

    it_behaves_like "check class info",
                    inputs: %i[identifier],
                    internals: %i[],
                    outputs: %i[]

    context "when the input arguments are valid" do
      describe "but the data required for work is invalid" do
        describe "because the value type is not a String for format validation" do
          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Input,
                "[Wrong::DynamicOptions::Format::WrongType::Example2] " \
                "Input `identifier` must be a String for `uuid` format validation"
              )
            )
          end
        end
      end
    end

    # NOTE: Will not work due to the wrong type for format validation.
    # context "when the input arguments are invalid" do
    #   it { expect { perform }.to have_input(:identifier).valid_with(attributes).type(Hash).required }
    # end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        identifier:
      }
    end

    let(:identifier) { { key: "value" } }

    it_behaves_like "check class info",
                    inputs: %i[identifier],
                    internals: %i[],
                    outputs: %i[]

    context "when the input arguments are valid" do
      describe "but the data required for work is invalid" do
        describe "because the value type is not a String for format validation" do
          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Input,
                "[Wrong::DynamicOptions::Format::WrongType::Example2] " \
                "Input `identifier` must be a String for `uuid` format validation"
              )
            )
          end
        end
      end
    end

    # NOTE: Will not work due to the wrong type for format validation.
    # context "when the input arguments are invalid" do
    #   it { expect { perform }.to have_input(:identifier).valid_with(attributes).type(Hash).required }
    # end
  end
end
