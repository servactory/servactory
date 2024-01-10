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
        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              NoMethodError,
              if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new("3.3.0")
                "undefined method `+' for nil"
              else
                "undefined method `+' for nil:NilClass"
              end
            )
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
        it "returns expected error" do
          expect { perform }.to(
            raise_error(
              NoMethodError,
              if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new("3.3.0")
                "undefined method `+' for nil"
              else
                "undefined method `+' for nil:NilClass"
              end
            )
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
