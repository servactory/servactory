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
                    outputs: %i[value]

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
          expect(perform).to(
            have_output(:value)
              .instance_of(Integer)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_output(:value, 500)
        )
      end

      it "stores execution on first call" do
        perform
        expect(idempotency_store.execution_count).to eq(1)
      end

      it "returns cached value on subsequent calls without re-executing", :aggregate_failures do
        # First call - executes and caches result
        first_result = described_class.call!(**attributes)
        expect(first_result.value).to eq(500)

        # Second call with same request_id - returns from cache, skips execution
        second_result = described_class.call!(**attributes)
        expect(second_result.value).to eq(500)

        # Only first call executes - second returns early from cache (true idempotency)
        expect(idempotency_store.execution_count).to eq(1)
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
          expect(perform).to(
            have_output(:value)
              .instance_of(Integer)
          )
        end
      end
    end

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it do
        expect(perform).to(
          be_success_service
            .with_output(:value, 1000)
        )
      end
    end
  end
end
