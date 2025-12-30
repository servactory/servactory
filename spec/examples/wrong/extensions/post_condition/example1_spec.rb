# frozen_string_literal: true

RSpec.describe Wrong::Extensions::PostCondition::Example1, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        amount: amount
      }
    end

    let(:amount) { -5 }

    context "when the post-condition fails" do
      it "raises an error" do
        expect { perform }.to(
          raise_error(
            ApplicationService::Exceptions::Failure,
            "Total must be positive"
          )
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

    let(:amount) { -5 }

    context "when the post-condition fails" do
      it "returns failure result", :aggregate_failures do
        result = perform

        expect(result).to be_a(Servactory::Result)
        expect(result).not_to be_success
        expect(result).to be_failure
        expect(result.error.type).to eq(:post_condition_failed)
        expect(result.error.message).to eq("Total must be positive")
      end
    end
  end
end
