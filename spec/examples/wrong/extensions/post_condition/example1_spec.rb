# frozen_string_literal: true

RSpec.describe Wrong::Extensions::PostCondition::Example1, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        amount:
      }
    end

    let(:amount) { 100 }

    it_behaves_like "check class info",
                    inputs: %i[amount],
                    internals: %i[],
                    outputs: %i[total]

    describe "but the data required for work is invalid" do
      describe "because post-condition fails" do
        it_behaves_like "failure result class"

        it "returns expected error", :aggregate_failures do
          expect { perform }.to(
            raise_error do |exception|
              expect(exception).to be_a(ApplicationService::Exceptions::Failure)
              expect(exception.type).to eq(:post_condition_failed)
              expect(exception.message).to eq("Total must be positive")
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
        amount:
      }
    end

    let(:amount) { 100 }

    describe "but the data required for work is invalid" do
      describe "because post-condition fails" do
        it_behaves_like "failure result class"

        it "returns the expected value in `error`", :aggregate_failures do
          result = perform

          expect(result.error).to be_a(ApplicationService::Exceptions::Failure)
          expect(result.error).to an_object_having_attributes(
            type: :post_condition_failed,
            message: "Total must be positive",
            meta: nil
          )
        end
      end
    end
  end
end
