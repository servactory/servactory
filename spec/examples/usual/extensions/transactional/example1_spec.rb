# frozen_string_literal: true

RSpec.describe Usual::Extensions::Transactional::Example1, type: :service do
  let(:transaction_class) { described_class::LikeAnActiveRecordTransaction }

  before { transaction_class.reset! }

  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        value: value
      }
    end

    let(:value) { 5 }

    it_behaves_like "check class info",
                    inputs: %i[value],
                    internals: %i[],
                    outputs: %i[result]

    context "when the input arguments are valid" do
      describe "and the transaction commits successfully" do
        it_behaves_like "success result class"

        it "returns the expected values", :aggregate_failures do
          result = perform

          expect(result).to be_a(Servactory::Result)
          expect(result).to be_success
          expect(result).not_to be_failure
          expect(result.result).to eq(50)
        end

        it "commits the transaction", :aggregate_failures do
          perform

          expect(transaction_class.transaction_started).to be(true)
          expect(transaction_class.transaction_committed).to be(true)
          expect(transaction_class.transaction_rolled_back).to be(false)
        end
      end
    end

    context "when the input arguments are invalid" do
      it do
        expect { perform }.to(
          have_input(:value)
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
        value: value
      }
    end

    let(:value) { 5 }

    it_behaves_like "check class info",
                    inputs: %i[value],
                    internals: %i[],
                    outputs: %i[result]

    context "when the input arguments are valid" do
      describe "and the transaction commits successfully" do
        it_behaves_like "success result class"

        it "returns the expected values", :aggregate_failures do
          result = perform

          expect(result).to be_a(Servactory::Result)
          expect(result).to be_success
          expect(result).not_to be_failure
          expect(result.result).to eq(50)
        end

        it "commits the transaction", :aggregate_failures do
          perform

          expect(transaction_class.transaction_started).to be(true)
          expect(transaction_class.transaction_committed).to be(true)
          expect(transaction_class.transaction_rolled_back).to be(false)
        end
      end
    end

    context "when the input arguments are invalid" do
      it do
        expect { perform }.to(
          have_input(:value)
            .valid_with(attributes)
            .type(Integer)
            .required
        )
      end
    end
  end
end
