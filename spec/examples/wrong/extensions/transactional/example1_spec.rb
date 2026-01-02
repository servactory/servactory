# frozen_string_literal: true

RSpec.describe Wrong::Extensions::Transactional::Example1, type: :service do
  let(:transaction_class) { described_class::LikeAnActiveRecordTransaction }

  before do
    transaction_class.reset!
  end

  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        value:
      }
    end

    let(:value) { 50 }

    it_behaves_like "check class info",
                    inputs: %i[value],
                    internals: %i[],
                    outputs: %i[total]

    describe "but the data required for work is invalid" do
      describe "because operation fails and transaction is rolled back" do
        it_behaves_like "failure result class"

        it "returns expected error and rolls back transaction", :aggregate_failures do
          expect { perform }.to(
            raise_error do |exception|
              expect(exception).to be_a(ApplicationService::Exceptions::Failure)
              expect(exception.type).to eq(:transaction_failed)
              expect(exception.message).to eq("Operation failed, rolling back")
              expect(exception.meta).to be_nil
            end
          )
          expect(transaction_class.transaction_started).to be(true)
          expect(transaction_class.transaction_committed).to be(false)
          expect(transaction_class.transaction_rolled_back).to be(true)
        end
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        value:
      }
    end

    let(:value) { 50 }

    describe "but the data required for work is invalid" do
      describe "because operation fails and transaction is rolled back" do
        it_behaves_like "failure result class"

        it "returns the expected value in `error`", :aggregate_failures do
          result = perform

          expect(result.error).to be_a(ApplicationService::Exceptions::Failure)
          expect(result.error).to an_object_having_attributes(
            type: :transaction_failed,
            message: "Operation failed, rolling back",
            meta: nil
          )
          expect(transaction_class.transaction_rolled_back).to be(true)
        end
      end
    end
  end
end
