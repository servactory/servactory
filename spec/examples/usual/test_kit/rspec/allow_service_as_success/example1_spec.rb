# frozen_string_literal: true

RSpec.describe Usual::TestKit::Rspec::AllowServiceAsSuccess::Example1, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call! }

    it_behaves_like "check class info",
                    inputs: %i[],
                    internals: %i[],
                    outputs: %i[child_result]

    describe "but the data required for work is invalid" do
      before do
        allow_service_as_success(Usual::TestKit::Rspec::AllowServiceAsSuccess::Example1Child)
      end

      it_behaves_like "success result class"

      it "does not raise error" do
        expect { perform }.not_to raise_error
      end

      it "returns success of child class" do
        expect(perform.child_result).to be_success_service
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call }

    it_behaves_like "check class info",
                    inputs: %i[],
                    internals: %i[],
                    outputs: %i[child_result]

    describe "but the data required for work is invalid" do
      before do
        allow_service_as_success(Usual::TestKit::Rspec::AllowServiceAsSuccess::Example1Child)
      end

      it_behaves_like "success result class"

      it "returns success of child class" do
        expect(perform.child_result).to be_success_service
      end
    end
  end
end
