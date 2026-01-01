# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::Format::Uuid::Message::Static::Example2, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        service_id:
      }
    end

    let(:service_id) { "018f0e5d-a7bd-7764-8b88-cdf2b2d22543" }

    it_behaves_like "check class info",
                    inputs: %i[service_id],
                    internals: %i[service_id],
                    outputs: %i[service_id]

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_output(:service_id, "018f0e5d-a7bd-7764-8b88-cdf2b2d22543")
        )
      end

      it do
        expect(perform).to(
          have_output(:service_id?).contains(true)
        )
      end
    end

    describe "but the data required for work is invalid" do
      describe "because the format is not suitable for `uuid`" do
        let(:service_id) { "my-best-uuid" }

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Internal,
              "Invalid date format"
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

    let(:service_id) { "018f0e5d-a7bd-7764-8b88-cdf2b2d22543" }

    it_behaves_like "check class info",
                    inputs: %i[service_id],
                    internals: %i[service_id],
                    outputs: %i[service_id]

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_output(:service_id, "018f0e5d-a7bd-7764-8b88-cdf2b2d22543")
        )
      end

      it do
        expect(perform).to(
          have_output(:service_id?).contains(true)
        )
      end
    end

    describe "but the data required for work is invalid" do
      describe "because the format is not suitable for `uuid`" do
        let(:service_id) { "my-best-uuid" }

        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              ApplicationService::Exceptions::Internal,
              "Invalid date format"
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
