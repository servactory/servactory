# frozen_string_literal: true

RSpec.describe Wrong::Prepare::Example4 do
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
                     outputs: %i[balance_with_bonus]

    context "when the input arguments are valid" do
      describe "but the data required for work is invalid" do
        it "returns expected error", :aggregate_failures do
          expect { perform }.to(
            raise_error do |exception|
              expect(exception).to be_a(ApplicationService::Exceptions::Failure)
              expect(exception.type).to eq(:base)
              expect(exception.message).to eq("[Wrong::Prepare::Example4] Undefined method `+` for `nil`")
              expect(exception.meta).to be_nil
            end
          )
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
                     outputs: %i[balance_with_bonus]

    context "when the input arguments are valid" do
      describe "but the data required for work is invalid" do
        include_examples "failure result class"

        it "returns the expected value in `errors`", :aggregate_failures do
          result = perform

          expect(result.error).to be_a(ApplicationService::Exceptions::Failure)
          expect(result.error).to an_object_having_attributes(
            type: :base,
            message: "[Wrong::Prepare::Example4] Undefined method `+` for `nil`",
            meta: nil
          )
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
