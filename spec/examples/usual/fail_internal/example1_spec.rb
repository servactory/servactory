# frozen_string_literal: true

RSpec.describe Usual::FailInternal::Example1, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        invoice_number:
      }
    end

    let(:invoice_number) { "AA-7650AE" }

    it_behaves_like "check class info",
                    inputs: %i[invoice_number],
                    internals: %i[invoice_number],
                    outputs: %i[invoice_number]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        it_behaves_like "success result class"

        it { expect(perform).to have_output(:invoice_number).contains("AA-7650AE") }
      end

      describe "but the data required for work is invalid" do
        describe "because invalid invoice number" do
          let(:invoice_number) { "BB-7650AE" }

          it "returns expected error", :aggregate_failures do
            expect { perform }.to(
              raise_error do |exception|
                expect(exception).to be_a(ApplicationService::Exceptions::Internal)
                expect(exception.service).to be_a(Servactory::Context::Workspace::Actor)
                expect(exception.service).to have_attributes(
                  class_name: "Usual::FailInternal::Example1"
                )
                expect(exception.service.translate("this.is.just.a.test")).to(
                  eq("Translation missing: en.servactory.this.is.just.a.test")
                )
                expect(exception.internal_name).to eq(:invoice_number)
                expect(exception.message).to eq("Invalid invoice number")
                expect(exception.meta).to match(received_invoice_number: "BB-7650AE")
              end
            )
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      it { expect { perform }.to have_input(:invoice_number).valid_with(attributes).type(String).required }
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        invoice_number:
      }
    end

    let(:invoice_number) { "AA-7650AE" }

    it_behaves_like "check class info",
                    inputs: %i[invoice_number],
                    internals: %i[invoice_number],
                    outputs: %i[invoice_number]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        it_behaves_like "success result class"

        it { expect(perform).to have_output(:invoice_number).contains("AA-7650AE") }
      end

      describe "but the data required for work is invalid" do
        describe "because invalid invoice number" do
          let(:invoice_number) { "BB-7650AE" }

          it "returns expected error", :aggregate_failures do
            expect { perform }.to(
              raise_error do |exception|
                expect(exception).to be_a(ApplicationService::Exceptions::Internal)
                expect(exception.service).to be_a(Servactory::Context::Workspace::Actor)
                expect(exception.service).to have_attributes(
                  class_name: "Usual::FailInternal::Example1"
                )
                expect(exception.service.translate("this.is.just.a.test")).to(
                  eq("Translation missing: en.servactory.this.is.just.a.test")
                )
                expect(exception.internal_name).to eq(:invoice_number)
                expect(exception.message).to eq("Invalid invoice number")
                expect(exception.meta).to match(received_invoice_number: "BB-7650AE")
              end
            )
          end
        end
      end
    end

    context "when the input arguments are invalid" do
      it { expect { perform }.to have_input(:invoice_number).valid_with(attributes).type(String).required }
    end
  end
end
