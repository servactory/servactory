# frozen_string_literal: true

RSpec.describe Usual::Stage::Example4, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call! }

    it_behaves_like "check class info",
                    inputs: %i[],
                    internals: %i[],
                    outputs: %i[number]

    describe "validations" do
      describe "outputs" do
        it { expect(perform).to be_success_service.with_output(:number, 9) }
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call }

    it_behaves_like "check class info",
                    inputs: %i[],
                    internals: %i[],
                    outputs: %i[number]

    describe "validations" do
      describe "outputs" do
        it { expect(perform).to be_success_service.with_output(:number, 9) }
      end
    end
  end
end
