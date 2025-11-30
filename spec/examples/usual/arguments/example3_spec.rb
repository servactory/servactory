# frozen_string_literal: true

RSpec.describe Usual::Arguments::Example3, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.activated(activated).call! }

    let(:activated) { true }

    it_behaves_like "check class info",
                    inputs: %i[activated],
                    internals: %i[activated],
                    outputs: %i[activated]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        it_behaves_like "success result class"

        it { expect(perform).to have_output(:activated).contains(true) }
      end
    end

    context "when the input arguments are invalid" do
      it { expect { perform }.to have_input(:activated).types(TrueClass, FalseClass).optional }
    end
  end

  describe ".call" do
    subject(:perform) { described_class.activated(activated).call }

    let(:activated) { true }

    it_behaves_like "check class info",
                    inputs: %i[activated],
                    internals: %i[activated],
                    outputs: %i[activated]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        it_behaves_like "success result class"

        it { expect(perform).to have_output(:activated).contains(true) }
      end
    end

    context "when the input arguments are invalid" do
      it { expect { perform }.to have_input(:activated).types(TrueClass, FalseClass).optional }
    end
  end
end
