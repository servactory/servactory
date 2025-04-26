# frozen_string_literal: true

RSpec.describe Usual::Arguments::Example3, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.locked(locked).call! }

    let(:locked) { true }

    it_behaves_like "check class info",
                    inputs: %i[locked],
                    internals: %i[locked],
                    outputs: %i[locked]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        it_behaves_like "success result class"

        it { expect(perform).to have_output(:locked).contains(true) }
      end
    end

    context "when the input arguments are invalid" do
      it { expect { perform }.to have_input(:locked).types(TrueClass, FalseClass).optional }
    end
  end

  describe ".call" do
    subject(:perform) { described_class.locked(locked).call }

    let(:locked) { true }

    it_behaves_like "check class info",
                    inputs: %i[locked],
                    internals: %i[locked],
                    outputs: %i[locked]

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        it_behaves_like "success result class"

        it { expect(perform).to have_output(:locked).contains(true) }
      end
    end

    context "when the input arguments are invalid" do
      it { expect { perform }.to have_input(:locked).types(TrueClass, FalseClass).optional }
    end
  end
end
