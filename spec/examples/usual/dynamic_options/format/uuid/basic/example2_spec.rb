# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::Format::Uuid::Basic::Example2, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        service_id:
      }
    end

    let(:service_id) { "018f0e5d-a7bd-7764-8b88-cdf2b2d22543" }

    include_examples "check class info",
                     inputs: %i[service_id],
                     internals: %i[service_id],
                     outputs: %i[service_id]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        it { expect(perform).to have_output(:service_id?).with(true) }
        it { expect(perform).to have_output(:service_id).with("018f0e5d-a7bd-7764-8b88-cdf2b2d22543") }
      end

      describe "but the data required for work is invalid" do
        describe "because the format is not suitable for `uuid`" do
          let(:service_id) { "my-best-uuid" }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Internal,
                "[Usual::DynamicOptions::Format::Uuid::Basic::Example2] " \
                "Internal attribute `service_id` does not match `uuid` format"
              )
            )
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      it { expect { perform }.to have_input(:service_id).valid_with(attributes).type(String).required }
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        service_id:
      }
    end

    let(:service_id) { "018f0e5d-a7bd-7764-8b88-cdf2b2d22543" }

    include_examples "check class info",
                     inputs: %i[service_id],
                     internals: %i[service_id],
                     outputs: %i[service_id]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        it { expect(perform).to have_output(:service_id?).with(true) }
        it { expect(perform).to have_output(:service_id).with("018f0e5d-a7bd-7764-8b88-cdf2b2d22543") }
      end

      describe "but the data required for work is invalid" do
        describe "because the format is not suitable for `uuid`" do
          let(:service_id) { "my-best-uuid" }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Internal,
                "[Usual::DynamicOptions::Format::Uuid::Basic::Example2] " \
                "Internal attribute `service_id` does not match `uuid` format"
              )
            )
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      it { expect { perform }.to have_input(:service_id).valid_with(attributes).type(String).required }
    end
  end
end
