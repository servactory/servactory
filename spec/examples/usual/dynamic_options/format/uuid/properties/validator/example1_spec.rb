# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::Format::Uuid::Properties::Validator::Example1, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        service_id:
      }
    end

    let(:service_id) { "my-best-uuid" }

    it_behaves_like "check class info",
                    inputs: %i[service_id],
                    internals: %i[],
                    outputs: %i[service_id]

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it "returns the expected value", :aggregate_failures do
        result = perform

        expect(result.service_id?).to be(true)
        expect(result.service_id).to eq("my-best-uuid")
      end
    end

    describe "but the data required for work is invalid" do
      describe "because the format is not suitable for `uuid`" do
        let(:service_id) { "uuid" }

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "[Usual::DynamicOptions::Format::Uuid::Properties::Validator::Example1] " \
              "Input `service_id` does not match `uuid` format"
            )
          )
        end
      end
    end

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:service_id)
              .valid_with(attributes)
              .type(String)
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
        service_id:
      }
    end

    let(:service_id) { "my-best-uuid" }

    it_behaves_like "check class info",
                    inputs: %i[service_id],
                    internals: %i[],
                    outputs: %i[service_id]

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it "returns the expected value", :aggregate_failures do
        result = perform

        expect(result.service_id?).to be(true)
        expect(result.service_id).to eq("my-best-uuid")
      end
    end

    describe "but the data required for work is invalid" do
      describe "because the format is not suitable for `uuid`" do
        let(:service_id) { "uuid" }

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Input,
              "[Usual::DynamicOptions::Format::Uuid::Properties::Validator::Example1] " \
              "Input `service_id` does not match `uuid` format"
            )
          )
        end
      end
    end

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:service_id)
              .valid_with(attributes)
              .type(String)
              .required
          )
        end
      end
    end
  end
end
