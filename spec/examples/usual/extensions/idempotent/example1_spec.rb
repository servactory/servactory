# frozen_string_literal: true

RSpec.describe Usual::Extensions::Idempotent::Example1, type: :service do
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

    let(:request_id) { "req-123" }
    let(:amount) { 20 }

    it_behaves_like "check class info",
                    inputs: %i[request_id amount],
                    internals: %i[],
                    outputs: %i[result]

    context "when the input arguments are valid" do
      describe "and this is the first execution" do
        it_behaves_like "success result class"

        it "returns the expected values", :aggregate_failures do
          result = perform

          expect(result).to be_a(Servactory::Result)
          expect(result).to be_success
          expect(result).not_to be_failure
          expect(result.result).to eq(100)
        end

        it "executes the service once" do
          perform

          expect(idempotency_store.execution_count).to eq(1)
        end

        it "stores the result for future requests" do
          perform

          expect(idempotency_store.get("req-123")).to eq({ result: 100 })
        end
      end
    end

    context "when the input arguments are invalid" do
      it do
        expect { perform }.to(
          have_input(:request_id)
            .valid_with(attributes)
            .type(String)
            .required
        )
      end

      it do
        expect { perform }.to(
          have_input(:amount)
            .valid_with(attributes)
            .type(Integer)
            .required
        )
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

    let(:request_id) { "req-123" }
    let(:amount) { 20 }

    it_behaves_like "check class info",
                    inputs: %i[request_id amount],
                    internals: %i[],
                    outputs: %i[result]

    context "when the input arguments are valid" do
      describe "and this is the first execution" do
        it_behaves_like "success result class"

        it "returns the expected values", :aggregate_failures do
          result = perform

          expect(result).to be_a(Servactory::Result)
          expect(result).to be_success
          expect(result).not_to be_failure
          expect(result.result).to eq(100)
        end

        it "executes the service once" do
          perform

          expect(idempotency_store.execution_count).to eq(1)
        end

        it "stores the result for future requests" do
          perform

          expect(idempotency_store.get("req-123")).to eq({ result: 100 })
        end
      end
    end

    context "when the input arguments are invalid" do
      it do
        expect { perform }.to(
          have_input(:request_id)
            .valid_with(attributes)
            .type(String)
            .required
        )
      end

      it do
        expect { perform }.to(
          have_input(:amount)
            .valid_with(attributes)
            .type(Integer)
            .required
        )
      end
    end
  end
end
