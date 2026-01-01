# frozen_string_literal: true

RSpec.describe Usual::ActionShortcuts::Example2, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call! }

    it_behaves_like "check class info",
                    inputs: %i[],
                    internals: %i[],
                    outputs: %i[]

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      # NOTE: This service has no outputs, commented check is intentional
      # it { expect(perform).to have_output(:number).contains(7) }
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call }

    it_behaves_like "check class info",
                    inputs: %i[],
                    internals: %i[],
                    outputs: %i[]

    describe "and the data required for work is also valid" do
      it_behaves_like "success result class"

      # NOTE: This service has no outputs, commented check is intentional
      # it { expect(perform).to have_output(:number).contains(7) }
    end
  end
end
