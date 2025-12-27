# frozen_string_literal: true

RSpec.describe Usual::TestKit::Rspec::MockServiceFluentApi::Example2, type: :service do
  describe ".call" do
    subject(:perform) { described_class.call }

    context "with sequential returns using then_as_success" do
      before do
        mock_service(Usual::TestKit::Rspec::MockServiceFluentApi::Example2Child)
          .as_success
          .with_outputs(attempt: 1)
          .then_as_success
          .with_outputs(attempt: 2)
          .then_as_success
          .with_outputs(attempt: 3)
      end

      it "returns sequential values on subsequent calls" do
        result = perform

        expect(result.results).to eq([1, 2, 3])
      end
    end

    context "with last value repeated for additional calls" do
      before do
        mock_service(Usual::TestKit::Rspec::MockServiceFluentApi::Example2Child)
          .as_success
          .with_outputs(attempt: 100)
          .then_as_success
          .with_outputs(attempt: 200)
      end

      it "repeats last value when called more times than configured" do
        result = perform

        expect(result.results).to eq([100, 200, 200])
      end
    end
  end
end
