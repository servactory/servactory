# frozen_string_literal: true

RSpec.describe Usual::Fail::Example1, type: :service do
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
              expect(exception.type).to eq(:base)
              expect(exception.message).to eq("Invalid invoice number")
              expect(exception.meta).to be_nil
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

        it_behaves_like "failure result class"

        it "returns the expected value in `errors`", :aggregate_failures do
          result = perform

          expect(result.error).to be_a(ApplicationService::Exceptions::Failure)
          expect(result.error).to an_object_having_attributes(
            type: :base,
            message: "Invalid invoice number",
            meta: nil
          )
        end
      end
    end
  end
end
