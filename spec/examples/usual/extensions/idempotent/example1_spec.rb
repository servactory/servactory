# frozen_string_literal: true

RSpec.describe Usual::Extensions::Idempotent::Example1, type: :service do
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

    describe "validations" do
      describe "inputs" do
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

      describe "outputs" do
        it do
          result = perform
          expect(result.result).to be_a(Integer)
        end
      end
    end

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it "executes and stores result on first call" do
        expect(perform).to be_success_service
        expect(perform.result).to eq(500)
        expect(idempotency_store.execution_count).to eq(1)
      end

      it "returns cached result on subsequent calls" do
        # First call
        first_result = described_class.call!(**attributes)
        expect(first_result.result).to eq(500)

        # Second call with same request_id - outputs restored from cache
        second_result = described_class.call!(**attributes)
        expect(second_result.result).to eq(500)

        # Both calls execute, but outputs are consistent due to caching
        expect(idempotency_store.execution_count).to eq(2)
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

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it "returns success with calculated result" do
        expect(perform).to be_success_service
        expect(perform.result).to eq(1000)
      end
    end
  end
end
