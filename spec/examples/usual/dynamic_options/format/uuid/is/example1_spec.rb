# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::Format::Uuid::Is::Example1, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        uuid: uuid
      }
    end

    let(:uuid) { "018f0e5d-a7bd-7764-8b88-cdf2b2d22543" }

    include_examples "check class info",
                     inputs: %i[uuid],
                     internals: %i[],
                     outputs: %i[uuid]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        it { expect(perform).to have_output(:uuid?).with(true) }
        it { expect(perform).to have_output(:uuid).with("018f0e5d-a7bd-7764-8b88-cdf2b2d22543") }
      end

      describe "but the data required for work is invalid" do
        describe "because the format is not suitable for `uuid`" do
          let(:uuid) { "my-best-uuid" }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Input,
                "[Usual::DynamicOptions::Format::Uuid::Is::Example1] " \
                "Input `uuid` does not match `uuid` format"
              )
            )
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      it { expect { perform }.to have_input(:uuid).valid_with(attributes).type(String).required }
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        uuid: uuid
      }
    end

    let(:uuid) { "018f0e5d-a7bd-7764-8b88-cdf2b2d22543" }

    include_examples "check class info",
                     inputs: %i[uuid],
                     internals: %i[],
                     outputs: %i[uuid]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        it { expect(perform).to have_output(:uuid?).with(true) }
        it { expect(perform).to have_output(:uuid).with("018f0e5d-a7bd-7764-8b88-cdf2b2d22543") }
      end

      describe "but the data required for work is invalid" do
        describe "because the format is not suitable for `uuid`" do
          let(:uuid) { "my-best-uuid" }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Input,
                "[Usual::DynamicOptions::Format::Uuid::Is::Example1] " \
                "Input `uuid` does not match `uuid` format"
              )
            )
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      it { expect { perform }.to have_input(:uuid).valid_with(attributes).type(String).required }
    end
  end
end
