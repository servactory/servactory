# frozen_string_literal: true

RSpec.describe Usual::Prepare::Example1, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        balance_cents: balance_cents
      }
    end

    let(:balance_cents) { 2_000_00 }

    include_examples "check class info",
                     inputs: %i[balance_cents],
                     internals: %i[],
                     outputs: [:balance_with_bonus]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        include_examples "success result class"

        it "returns the expected values", :aggregate_failures do
          result = perform

          expect(result.balance_with_bonus).to be_a(Usual::Prepare::Example1::Money)
          expect(result.balance_with_bonus.cents).to eq(3_000_00)
          expect(result.balance_with_bonus.currency).to eq(:USD)
        end
      end
    end

    context "when the input arguments are invalid" do
      context "when `balance_cents`" do
        it_behaves_like "input required check", name: :balance_cents
        it_behaves_like "input type check", name: :balance_cents, expected_type: Integer
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        balance_cents: balance_cents
      }
    end

    let(:balance_cents) { 2_000_00 }

    include_examples "check class info",
                     inputs: %i[balance_cents],
                     internals: %i[],
                     outputs: [:balance_with_bonus]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        include_examples "success result class"

        it "returns the expected values", :aggregate_failures do
          result = perform

          expect(result.balance_with_bonus).to be_a(Usual::Prepare::Example1::Money)
          expect(result.balance_with_bonus.cents).to eq(3_000_00)
          expect(result.balance_with_bonus.currency).to eq(:USD)
        end
      end
    end

    context "when the input arguments are invalid" do
      context "when `balance_cents`" do
        it_behaves_like "input required check", name: :balance_cents
        it_behaves_like "input type check", name: :balance_cents, expected_type: Integer
      end
    end
  end
end
