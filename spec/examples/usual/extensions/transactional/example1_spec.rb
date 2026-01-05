# frozen_string_literal: true

RSpec.describe Usual::Extensions::Transactional::Example1, type: :service do
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
            .with_output(:total, 500)
        )
      end

      it "commits transaction", :aggregate_failures do
        perform
        expect(transaction_class.transaction_started).to be(true)
        expect(transaction_class.transaction_committed).to be(true)
        expect(transaction_class.transaction_rolled_back).to be(false)
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
            .with_output(:total, 500)
        )
      end

      it "commits transaction", :aggregate_failures do
        perform
        expect(transaction_class.transaction_started).to be(true)
        expect(transaction_class.transaction_committed).to be(true)
      end
    end
  end
end
