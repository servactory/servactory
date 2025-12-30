# frozen_string_literal: true

RSpec.describe Wrong::Extensions::Transactional::Example1, type: :service do
  let(:transaction_class) { described_class::LikeAnActiveRecordTransaction }

  before { transaction_class.reset! }

  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        value: value,
        should_fail: should_fail
      }
    end

    let(:value) { 5 }
    let(:should_fail) { true }

    context "when the service fails" do
      it "raises an error" do
        expect { perform }.to(
          raise_error(
            ApplicationService::Exceptions::Failure,
            "Processing failed"
          )
        )
      end

      it "rolls back the transaction", :aggregate_failures do
        expect { perform }.to raise_error(ApplicationService::Exceptions::Failure)

        expect(transaction_class.transaction_started).to be(true)
        expect(transaction_class.transaction_committed).to be(false)
        expect(transaction_class.transaction_rolled_back).to be(true)
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        value: value,
        should_fail: should_fail
      }
    end

    let(:value) { 5 }
    let(:should_fail) { true }

    context "when the service fails" do
      it "returns failure result", :aggregate_failures do
        result = perform

        expect(result).to be_a(Servactory::Result)
        expect(result).not_to be_success
        expect(result).to be_failure
        expect(result.error.type).to eq(:processing_error)
        expect(result.error.message).to eq("Processing failed")
      end

      it "rolls back the transaction", :aggregate_failures do
        perform

        expect(transaction_class.transaction_started).to be(true)
        expect(transaction_class.transaction_committed).to be(false)
        expect(transaction_class.transaction_rolled_back).to be(true)
      end
    end
  end
end
