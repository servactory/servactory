# frozen_string_literal: true

RSpec.describe Wrong::Extensions::Idempotent::Example1, type: :service do
  let(:idempotency_store) { described_class::LikeAnIdempotencyStore }

  before { idempotency_store.reset! }

  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        request_id: request_id,
        amount: amount
      }
    end

    let(:request_id) { "req-duplicate" }
    let(:amount) { 20 }

    context "when the request is a duplicate" do
      before do
        described_class.call!(**attributes)
      end

      it "returns cached outputs on duplicate request", :aggregate_failures do
        result = perform

        expect(result).to be_a(Servactory::Result)
        expect(result).to be_success
        expect(result.result).to eq(100)
      end

      it "uses cached outputs instead of newly computed values" do
        # First call stored { result: 100 }
        # Second call: even though service runs, outputs are overwritten with cached values
        result = perform

        expect(result.result).to eq(100)
        expect(idempotency_store.get("req-duplicate")).to eq({ result: 100 })
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        request_id: request_id,
        amount: amount
      }
    end

    let(:request_id) { "req-duplicate" }
    let(:amount) { 20 }

    context "when the request is a duplicate" do
      before do
        described_class.call(**attributes)
      end

      it "returns cached outputs on duplicate request", :aggregate_failures do
        result = perform

        expect(result).to be_a(Servactory::Result)
        expect(result).to be_success
        expect(result.result).to eq(100)
      end

      it "uses cached outputs instead of newly computed values" do
        result = perform

        expect(result.result).to eq(100)
        expect(idempotency_store.get("req-duplicate")).to eq({ result: 100 })
      end
    end
  end
end
