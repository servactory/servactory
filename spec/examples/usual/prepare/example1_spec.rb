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

        it { expect(perform).to have_output(:balance_with_bonus).instance_of(Usual::Prepare::Example1::Money) }
        it { expect(perform).to have_output(:balance_with_bonus).nested(:cents).with(3_000_00) }
        it { expect(perform).to have_output(:balance_with_bonus).nested(:currency).with(:USD) }
      end
    end

    context "when the input arguments are invalid" do
      it { expect { perform }.to have_input(:balance_cents).simulation(attributes).type(Integer).required }
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

        it { expect(perform).to have_output(:balance_with_bonus).instance_of(Usual::Prepare::Example1::Money) }
        it { expect(perform).to have_output(:balance_with_bonus).nested(:cents).with(3_000_00) }
        it { expect(perform).to have_output(:balance_with_bonus).nested(:currency).with(:USD) }
      end
    end

    context "when the input arguments are invalid" do
      it { expect { perform }.to have_input(:balance_cents).simulation(attributes).type(Integer).required }
    end
  end
end
