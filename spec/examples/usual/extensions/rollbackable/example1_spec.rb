# frozen_string_literal: true

RSpec.describe Usual::Extensions::Rollbackable::Example1, type: :service do
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

    describe "validations" do
      describe "inputs" do
        it do
          expect { perform }.to(
            have_input(:value)
              .valid_with(attributes)
              .type(Integer)
              .required
          )
        end
      end

      describe "outputs" do
        it do
          result = perform
          expect(result.total).to be_a(Integer)
        end
      end
    end

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it "returns success with total without calling rollback", :aggregate_failures do
        expect(perform).to be_success_service
        expect(perform.total).to eq(150)
        expect(rollback_tracker.rollback_called).to be(false)
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

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      it "returns success without calling rollback", :aggregate_failures do
        expect(perform).to be_success_service
        expect(perform.total).to eq(150)
        expect(rollback_tracker.rollback_called).to be(false)
      end
    end
  end
end
