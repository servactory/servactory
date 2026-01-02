# frozen_string_literal: true

RSpec.describe Wrong::Extensions::Idempotent::Example1, type: :service do
  let(:idempotency_store) { described_class::LikeAnIdempotencyStore }

  before do
    idempotency_store.reset!
  end

  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        request_id:,
        amount:
      }
    end

    let(:request_id) { "unique-request-123" }
    let(:amount) { 100 }

    it_behaves_like "check class info",
                    inputs: %i[request_id amount],
                    internals: %i[],
                    outputs: %i[result]

    describe "but the data required for work is invalid" do
      describe "because operation fails during processing" do
        it "returns expected error", :aggregate_failures do
          expect { perform }.to(
            raise_error do |exception|
              expect(exception).to be_a(ApplicationService::Exceptions::Failure)
              expect(exception.type).to eq(:processing_failed)
              expect(exception.message).to eq("Failed to process amount")
            end
          )
          expect(idempotency_store.execution_count).to eq(1)
        end
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        request_id:,
        amount:
      }
    end

    let(:request_id) { "unique-request-456" }
    let(:amount) { 200 }

    describe "but the data required for work is invalid" do
      describe "because operation fails during processing" do
        it "returns the expected value in `error`", :aggregate_failures do
          result = perform

          expect(result.error).to be_a(ApplicationService::Exceptions::Failure)
          expect(result.error).to an_object_having_attributes(
            type: :processing_failed,
            message: "Failed to process amount"
          )
        end
      end
    end
  end
end
