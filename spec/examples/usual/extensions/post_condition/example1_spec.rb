# frozen_string_literal: true

RSpec.describe Usual::Extensions::PostCondition::Example1, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        amount: amount
      }
    end

    let(:amount) { 10 }

    it_behaves_like "check class info",
                    inputs: %i[amount],
                    internals: %i[],
                    outputs: %i[total]

    context "when the input arguments are valid" do
      describe "and the post-condition passes" do
        it_behaves_like "success result class"

        it "returns the expected values", :aggregate_failures do
          result = perform

          expect(result).to be_a(Servactory::Result)
          expect(result).to be_success
          expect(result).not_to be_failure
          expect(result.total).to eq(20)
        end
      end
    end

    context "when the input arguments are invalid" do
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
        amount: amount
      }
    end

    let(:amount) { 10 }

    it_behaves_like "check class info",
                    inputs: %i[amount],
                    internals: %i[],
                    outputs: %i[total]

    context "when the input arguments are valid" do
      describe "and the post-condition passes" do
        it_behaves_like "success result class"

        it "returns the expected values", :aggregate_failures do
          result = perform

          expect(result).to be_a(Servactory::Result)
          expect(result).to be_success
          expect(result).not_to be_failure
          expect(result.total).to eq(20)
        end
      end
    end

    context "when the input arguments are invalid" do
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
