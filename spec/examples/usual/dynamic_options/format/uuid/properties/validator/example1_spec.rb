# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::Format::Uuid::Properties::Validator::Example1, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        uuid: uuid
      }
    end

    let(:uuid) { "my-best-uuid" }

    include_examples "check class info",
                     inputs: %i[uuid],
                     internals: %i[],
                     outputs: %i[uuid]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        it "returns the expected value", :aggregate_failures do
          result = perform

          expect(result.uuid?).to be(true)
          expect(result.uuid).to eq("my-best-uuid")
        end
      end

      describe "but the data required for work is invalid" do
        describe "because the format is not suitable for `uuid`" do
          let(:uuid) { "uuid" }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Input,
                "[Usual::DynamicOptions::Format::Uuid::Properties::Validator::Example1] " \
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

    let(:uuid) { "my-best-uuid" }

    include_examples "check class info",
                     inputs: %i[uuid],
                     internals: %i[],
                     outputs: %i[uuid]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        it "returns the expected value", :aggregate_failures do
          result = perform

          expect(result.uuid?).to be(true)
          expect(result.uuid).to eq("my-best-uuid")
        end
      end

      describe "but the data required for work is invalid" do
        describe "because the format is not suitable for `uuid`" do
          let(:uuid) { "uuid" }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Input,
                "[Usual::DynamicOptions::Format::Uuid::Properties::Validator::Example1] " \
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
