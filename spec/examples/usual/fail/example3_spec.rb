# frozen_string_literal: true

RSpec.describe Usual::Fail::Example3, type: :service do
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
                    internals: %i[],
                    outputs: %i[invoice_number]

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:invoice_number)
              .valid_with(attributes)
              .type(String)
              .required
          )
        end
      end
    end

    describe "outputs" do
      it do
        expect(perform).to(
          have_output(:invoice_number)
            .instance_of(String)
        )
      end
    end

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_output(:invoice_number, "AA-7650AE")
        )
      end
    end

    describe "but the data required for work is invalid" do
      describe "because invalid invoice number" do
        let(:invoice_number) { "BB-7650AE" }

        it "returns expected error", :aggregate_failures do
          expect { perform }.to(
            raise_error do |exception|
              expect(exception).to be_a(ApplicationService::Exceptions::Failure)
              expect(exception.type).to eq(:validation)
              expect(exception.message).to eq("Invalid invoice number")
              expect(exception.meta).to match(invoice_number: "BB-7650AE")
              expect(exception.all?).to be(false) # because it doesn't make sense
              expect(exception.base?).to be(false)
              expect(exception.validation?).to be(true)
              expect(exception.respond_to?(:all?)).to be(false) # because it doesn't make sense
              expect(exception.respond_to?(:base?)).to be(false)
              expect(exception.respond_to?(:validation?)).to be(true)
            end
          )
        end
      end
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
                    internals: %i[],
                    outputs: %i[invoice_number]

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:invoice_number)
              .valid_with(attributes)
              .type(String)
              .required
          )
        end
      end
    end

    describe "outputs" do
      it do
        expect(perform).to(
          have_output(:invoice_number)
            .instance_of(String)
        )
      end
    end

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_output(:invoice_number, "AA-7650AE")
        )
      end
    end

    describe "but the data required for work is invalid" do
      describe "because invalid invoice number" do
        let(:invoice_number) { "BB-7650AE" }

        # include_examples "failure result class"

        it "returns failure result class", :aggregate_failures do
          result = perform

          expect(result).to be_a(Servactory::Result)
          expect(result.success?).to be(false)
          expect(result.failure?).to be(true)
          expect(result.failure?(:all)).to be(true)
          expect(result.failure?(:base)).to be(false)
          expect(result.failure?(:validation)).to be(true)
          expect(result.error.all?).to be(false) # because it doesn't make sense
          expect(result.error.base?).to be(false)
          expect(result.error.validation?).to be(true)
          expect(result.error.respond_to?(:all?)).to be(false) # because it doesn't make sense
          expect(result.error.respond_to?(:base?)).to be(false)
          expect(result.error.respond_to?(:validation?)).to be(true)
        end

        it "returns the expected value in `errors`", :aggregate_failures do
          result = perform

          expect(result.error).to be_a(ApplicationService::Exceptions::Failure)
          expect(result.error).to an_object_having_attributes(
            type: :validation,
            message: "Invalid invoice number",
            meta: {
              invoice_number: "BB-7650AE"
            }
          )
        end
      end
    end
  end
end
