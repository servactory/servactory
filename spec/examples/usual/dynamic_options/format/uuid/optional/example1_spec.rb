# frozen_string_literal: true

RSpec.describe Usual::DynamicOptions::Format::Uuid::Optional::Example1, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        service_id:
      }
    end

    let(:service_id) { nil }

    it_behaves_like "check class info",
                    inputs: %i[service_id],
                    internals: %i[],
                    outputs: %i[service_id]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        it { expect(perform).to have_output(:service_id?).contains(false) }
        it { expect(perform).to have_output(:service_id).contains(nil) }
      end

      describe "but the data required for work is invalid" do
        describe "because the format is not suitable for `uuid`" do
          let(:service_id) { "my-best-uuid" }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Input,
                "[Usual::DynamicOptions::Format::Uuid::Optional::Example1] " \
                "Input `service_id` does not match `uuid` format"
              )
            )
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      it { expect { perform }.to have_input(:service_id).valid_with(attributes).type(String).optional }
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        service_id:
      }
    end

    let(:service_id) { nil }

    it_behaves_like "check class info",
                    inputs: %i[service_id],
                    internals: %i[],
                    outputs: %i[service_id]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        it { expect(perform).to have_output(:service_id?).contains(false) }
        it { expect(perform).to have_output(:service_id).contains(nil) }
      end

      describe "but the data required for work is invalid" do
        describe "because the format is not suitable for `uuid`" do
          let(:service_id) { "my-best-uuid" }

          it "returns expected error" do
            expect { perform }.to(
              raise_error(
                ApplicationService::Exceptions::Input,
                "[Usual::DynamicOptions::Format::Uuid::Optional::Example1] " \
                "Input `service_id` does not match `uuid` format"
              )
            )
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      it { expect { perform }.to have_input(:service_id).valid_with(attributes).type(String).optional }
    end
  end
end
