# frozen_string_literal: true

RSpec.describe Wrong::Prepare::Example4, type: :service do
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
              expect(exception).to be_a(NoMethodError)
              expect(exception.message).to match(/undefined method `\+' for nil|:NilClass/)
            end
          )
        end
      end
    end

    context "when the input arguments are invalid" do
      it "returns expected inputs", :aggregate_failures do
        expect { perform }.to have_input(:balance_cents).type(Integer).required
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
        it "returns expected error", :aggregate_failures do
          expect { perform }.to(
            raise_error do |exception|
              expect(exception).to be_a(NoMethodError)
              expect(exception.message).to match(/undefined method `\+' for nil|:NilClass/)
            end
          )
        end
      end
    end

    context "when the input arguments are invalid" do
      it "returns expected inputs", :aggregate_failures do
        expect { perform }.to have_input(:balance_cents).type(Integer).required
      end
    end
  end
end
