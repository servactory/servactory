# frozen_string_literal: true

RSpec.describe Usual::Extensions::Rollbackable::Example2, type: :service do
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
          expect(perform).to(
            have_output(:total)
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
            .with_output(:total, 150)
        )
      end

      it "does not call rollback on success!" do
        perform
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
          expect(perform).to(
            have_output(:total)
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
            .with_output(:total, 150)
        )
      end

      it "does not call rollback on success!" do
        perform
        expect(rollback_tracker.rollback_called).to be(false)
      end
    end
  end
end
