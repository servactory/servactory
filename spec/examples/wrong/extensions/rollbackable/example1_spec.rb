# frozen_string_literal: true

RSpec.describe Wrong::Extensions::Rollbackable::Example1, type: :service do
  let(:rollback_tracker) { described_class::LikeARollbackTracker }

  before do
    rollback_tracker.reset!
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
      describe "because operation fails and rollback is triggered" do
        it "returns expected error and calls rollback", :aggregate_failures do
          expect { perform }.to(
            raise_error do |exception|
              expect(exception).to be_a(ApplicationService::Exceptions::Failure)
              expect(exception.type).to eq(:operation_failed)
              expect(exception.message).to eq("Something went wrong")
              expect(exception.meta).to be_nil
            end
          )
          expect(rollback_tracker.rollback_called).to be(true)
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
      describe "because operation fails and rollback is triggered" do
        it "returns the expected value in `error`", :aggregate_failures do
          result = perform

          expect(result.error).to be_a(ApplicationService::Exceptions::Failure)
          expect(result.error).to an_object_having_attributes(
            type: :operation_failed,
            message: "Something went wrong",
            meta: nil
          )
          expect(rollback_tracker.rollback_called).to be(true)
        end
      end
    end
  end
end
